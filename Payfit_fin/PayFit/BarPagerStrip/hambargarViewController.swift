//
//  hambargarViewController.swift
//  PayFit
//
//  Created by swuad_19 on 18/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import Parse
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase

class HambargarViewController: UIViewController, FUIAuthDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            self.listTableView.dequeueReusableCell(withIdentifier: "listCell")! as UITableViewCell
        cell.textLabel?.text = self.data[indexPath.row].title
        return cell
        
    }
    
    var dbRef = Database.database().reference()
    var data:[Pay] = []
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var nick: UILabel!
    @IBOutlet var profileimage: UIImageView!
    let authUI = FUIAuth.defaultAuthUI()
    
    override func viewWillAppear(_ animated: Bool) {
        let ad = UIApplication.shared.delegate as? AppDelegate
        
        nick.text = ad?.paramNickname ?? "슈니"
        
        
        let url = URL(string: (ad?.paramImage ?? "https://i.ibb.co/BGxhfLM/defalut-profile-icon-01.png")!)
        let IMGdata = try? Data(contentsOf: url!)
        profileimage.image = UIImage(data: IMGdata!)
        profileimage.layer.cornerRadius = (profileimage.frame.height)/2
        dbRef = Database.database().reference()
        listTableView.dataSource = self
        getData()
        
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
    
    
    @IBAction func doLogout(_ sender: UIButton) {
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
    
    func getData() {
        if let userID = Auth.auth().currentUser?.uid {
            let postRef = dbRef.child("pay").child("\(userID)")
            let refHandle = postRef.queryOrdered(byChild: "returndate").observe(DataEventType.value) { (snapshot) in
                self.data = []
                let snapshot_data = snapshot.children.allObjects as! [DataSnapshot]
                for pay in snapshot_data {
                    let pay = try! FirebaseDecoder().decode(Pay.self, from: pay.value)
                    self.data.append(pay)
                }
                self.listTableView.reloadData()
            }
        }
    }
    
    
}
