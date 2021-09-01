//
//  LoginViewController.swift
//  PayFit
//
//  Created by swuad_19 on 15/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseUI
import FirebaseAuth
import KakaoOpenSDK
import Alamofire

class LoginViewController: UIViewController {
    lazy var functions = Functions.functions(region: "us-central1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 로그인이 된 상태인지 확인코드
        if let user = Auth.auth().currentUser {
            emailTextField.placeholder = "이미 로그인 된 상태입니다"
            pwTextField.placeholder = "이미 로그인 된 상태입니다"
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBAction func didEmailLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let pw = pwTextField.text else {return}
        
        //사용자가 앱에 로그인하면 다음과 같이 해당 사용자의 이메일 주소와 비번을 전달
        Auth.auth().signIn(withEmail: email, password: pw, completion: {(user, error) in
            if error != nil {
                NSLog("login fail")
            } else {
                NSLog("login success")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "tabbarView") as! UITabBarController
                mainViewController.modalPresentationStyle = .fullScreen
                self.present(mainViewController, animated: true, completion: nil)
            }
        }
        )
    }
}
