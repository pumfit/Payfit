//
//  FUIKakaoAuth.swift
//  PayFit
//
//  Created by swuad_19 on 07/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import FirebaseUI
import KakaoOpenSDK
import FirebaseFunctions
import Alamofire

class FUIKakaoAuth: NSObject, FUIAuthProvider {
    lazy var functions = Functions.functions(region: "us-central1")
    
    var shortName: String = "KakaoTalk"
    
    var providerID: String? = "KakaoTalk"
    
    var accessToken: String?
    
    var signInLabel: String = "카카오톡으로 로그인"
    
    var icon: UIImage = UIImage(named: "kakao")!
    
    var buttonBackgroundColor: UIColor = UIColor(red: 1, green: 217/255.0, blue: 69/255.0, alpha: 1)
    
    var buttonTextColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    //유저 정보 저장을 위한 변수선언
    var userNickname: String = ""
    var userImage: String = ""
    
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
        guard let session = KOSession.shared() else {
            return
        }
        
        if session.isOpen() {
            session.close()
        }
        let activityView = FUIAuthBaseViewController.addActivityIndicator(presentingViewController!.view)
        activityView.startAnimating()
        session.open { (error) in
            if let error = error {
                NSLog("로그인 실패")
            } else {
                NSLog("로그인 성공")
                // 성공했다면 파이어베이스 로그인
                // kakao uid 찾기
                KOSessionTask.userMeTask {(error, user_me) in
                    if let error = error {
                        NSLog(error.localizedDescription)
                    }
                    if let user = user_me{
                        let uid = user.id!
                        NSLog("user id:","\(uid)")
                        
                        // 유저 닉네임과 프로필사진 정보 가져오기
                        self.userNickname = (user.properties!["nickname"] ?? nil)!
                        self.userImage = (user.properties!["profile_image"] ?? nil)!
                        // 유저정보 보내주는 함수실행
                        self.userInfoDelegate()
                        
                        let login_info = TokenInfo(uid: user.id!)
                        AF.request("https://us-central1-payfit-4c4cc.cloudfunctions.net/getJMT",method:.post , parameters:
                            login_info, encoder:
                            URLEncodedFormParameterEncoder(destination:. httpBody)).responseJSON { (response) in
                                do{
                                    let token_data = try JSONDecoder().decode(JWT.self, from: response.data!)
                                    if token_data.error! == false{//에러없음
                                        NSLog(token_data.jwt!)
                                        Auth.auth().signIn(withCustomToken: token_data.jwt!)
                                        {(result,error)in
                                            if let error = error {
                                                NSLog("로그인 실패")
                                            } else {
                                                NSLog("파이어베이스 로그인 성공")
                                                //첫 시작인 경우만
                                                if let current_user = Auth.auth().currentUser, let email = user.account!.email{
                                                    current_user.updateEmail(to: email){(error) in
                                                        if let error = error{
                                                            NSLog("email update error")
                                                        } else {
                                                            NSLog("email update complete")
                                                        }
                                                        activityView.stopAnimating()
                                                        presentingViewController?.dismiss(animated: true, completion: nil)
                                                        // 뷰 이동 코드
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    //Functions를 이용해 받아온 토큰 파싱
                                }catch{
                                    NSLog(error.localizedDescription)
                                }
                                
                        }
                        //Functions를 이용해서 토큰 요청 //원래는 매개변수로 주소를 적었어야 하지만 함수명으로도 호출가능
                        self.functions.httpsCallable("makeJWT").call(["uid":uid]) { (result, error) in
                            if let error = error {
                                NSLog(error.localizedDescription)
                            }else {
                                if let data = (result?.data as? [String:Any]) {
                                    NSLog("토큰 받아옴")
                                    NSLog("\(data["jwt"])")
                                }
                            }
                        }
                    }
                }
                // 창 닫기
            }
        }
    }
    
    func signOut() {
        // 로그아웃
    }
    // 유저정보 전달 위해 Appdelegate에 값 저장
    func userInfoDelegate() {
        let ad = UIApplication.shared.delegate as? AppDelegate
        ad?.paramNickname = self.userNickname
        ad?.paramImage = self.userImage
    }
}
