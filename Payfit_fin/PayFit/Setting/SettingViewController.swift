//
//  SettingViewController.swift
//  PayFit
//
//  Created by swuad_19 on 15/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class SettingViewController: UIViewController, FUIAuthDelegate, UITableViewDataSource{
    
    var cellList:[String] = ["allAlertCell","eachListAlertCell"]
    
    let authUI = FUIAuth.defaultAuthUI()
    
    @IBOutlet var settingTableView: UITableView!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nick: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.rowHeight = 60
    }
    override func viewWillAppear(_ animated: Bool) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        
        nick.text = ad?.paramNickname ?? "슈니"
                
        let url = URL(string: (ad?.paramImage ?? "https://i.ibb.co/BGxhfLM/defalut-profile-icon-01.png")!)
        let IMGdata = try? Data(contentsOf: url!)
        profile.image = UIImage(data: IMGdata!)
        profile.layer.cornerRadius = (profile.frame.height)/2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellList[indexPath.row],for:indexPath)
        return cell
    }
    
    func loadLoginScreen(){
        let mainVC = self.storyboard!.instantiateViewController(withIdentifier: "mypagertabView")
        mainVC.modalPresentationStyle = .fullScreen
        if let user = Auth.auth().currentUser {
            let mainViewController = self.storyboard?.instantiateViewController(identifier: "tabbarView") as! UITabBarController
            mainViewController.modalPresentationStyle = .fullScreen
            self.present(mainViewController, animated: false, completion: nil)
        } else {
            let providers:[FUIAuthProvider] = [
                FUIGoogleAuth(),
                FUIKakaoAuth(),
                FUIEmailAuth2()
            ]
            
            self.authUI!.providers = providers
            self.authUI!.delegate = self
            
            let authViewController = customAuthViewController(authUI: self.authUI!)
            authViewController.modalPresentationStyle = .fullScreen
            
            self.present(authViewController, animated: true, completion: nil)
        }
        present(mainVC, animated: true, completion: nil)
    }
    
    @IBAction func doLogout(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        do{
            try! Auth.auth().signOut()
            NSLog("로그아웃 성공01")
            loadLoginScreen()
            NSLog("로그아웃 성공02")
        }catch{
            NSLog("로그아웃 실패")
        }
    }
    
}
