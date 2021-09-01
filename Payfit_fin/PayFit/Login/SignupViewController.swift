//
//  SignupViewController.swift
//  PayFit
//
//  Created by swuad_19 on 15/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBAction func signUpAction(_ sender: Any) {
        doSignUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SignupViewController{
    func showAlert(message:String){
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    func doSignUp(){
        if emailTextField.text! == ""{
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        
        if pwTextField.text! == ""{
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }
        signUp(email: emailTextField.text!, password: pwTextField.text!)
    }
    func signUp(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error != nil{
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일 입니다")
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입한 회원 입니다")
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 6자리 이상이여야해요")
                    default:
                        print(ErrorCode)
                    }
                }
            } else {
                NSLog("회원가입 성공")
                //회원가입하면 자동으로 로그인되게 함
                Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
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
        })
    }
}
