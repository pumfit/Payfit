//
//  ViewController.swift
//  PayFit
//
//  Created by swuad_19 on 07/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import Firebase
import Alamofire
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase
import SwiftyGif
import Parse

class ViewController: UIViewController, FUIAuthDelegate, SwiftyGifDelegate {
    
    let authUI = FUIAuth.defaultAuthUI()
    @IBOutlet weak var image_view: UIImageView!
    let token_url = "https://us-central1-payfit-4c4cc.cloudfunctions.net/getJMT"
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let gif = try UIImage(gifName: "payfitgif_AP.gif")
            self.image_view.setGifImage(gif)
            self.image_view.loopCount = 2
            self.image_view.startAnimating()
            self.image_view.delegate = self //변호사 선임
        } catch{
            print("gif 없음")
        }
        gifDidStop(sender: self.image_view)
    }
    //gif가 멈추면 실행되는 코드
    func gifDidStop(sender: UIImageView) {
        
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
        
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        NSLog("login complete")
        if let error = error {
            NSLog(error.localizedDescription)
            return
        }
        if let user = Auth.auth().currentUser {
            let user_id = user.uid
            let ref = Database.database().reference()
            ref.child("users").child(user_id).observeSingleEvent(of: .value, with: {
                (snapshot) in
                // 유저의 정보를 가져왔을 때 처리
                if let value = snapshot.value {
                    do {
                        let user = try FirebaseDecoder().decode(User.self, from: value)
                        NSLog("정보 있음")
                        dump(user)
                    } catch let error {
                        NSLog(error.localizedDescription)
                        NSLog("추가 정보 입력 필요")
                        // 가상유저 데이터 집어넣기
                        let user = User(name: "PayFit", email: "in5451@naver.com")
                        let data = try! FirebaseEncoder().encode(user)
                        ref.child("users").child(user_id).setValue(data)
                    }
                    let mainViewController = self.storyboard?.instantiateViewController(identifier: "tabbarView") as! UITabBarController
                    mainViewController.modalPresentationStyle = .fullScreen
                    self.present(mainViewController, animated: false, completion: nil)
                }
            }){
                (error) in
                NSLog(error.localizedDescription)
            }
        }
    }
}


