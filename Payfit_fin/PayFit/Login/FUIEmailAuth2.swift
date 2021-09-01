//
//  FUIEmailAuth2.swift
//  PayFit
//
//  Created by swuad_19 on 16/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseUI
import KakaoOpenSDK
import FirebaseFunctions
import Alamofire

class FUIEmailAuth2: NSObject, FUIAuthProvider {
    lazy var functions = Functions.functions(region: "us-central1")
    
    var shortName: String = "Email"
    
    var providerID: String? = "Email"
    
    var accessToken: String?
    
    var signInLabel: String = "Email로 로그인하기"
    
    var icon: UIImage = UIImage(named: "email")!
    
    var buttonBackgroundColor: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    
    var buttonTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    func signIn(withEmail email: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
    }
    // 카카오 로그인 설정 - developers.kakao.com 에 앱 추가
    // Info.plist - KAKAO_APP_KEY 추가, URL 추가, 추가 스키마 추가
    // Functions 폴더 새로 만들기 - 어제했던 KakaoNodeApp 처럼 하나 더 만들기
    
    func signIn(withDefaultValue defaultValue: String?, presenting presentingViewController: UIViewController?, completion: FUIAuthProviderSignInCompletionBlock? = nil) {
        // 카카오 로그인 시작
        // 카카오 로그인이 끝나면 UID, email 얻기
        // 파이어베이스 로그인하기
        // 현재 로그인 목록창 끄기
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "LoginView")
        
        presentingViewController?.present(login, animated: true, completion: nil)
        
    }
    
    func signOut() {
        // 로그아웃
    }
    
}
