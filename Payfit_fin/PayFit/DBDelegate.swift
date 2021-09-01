//
//  DBDelegate.swift
//  PayFit
//
//  Created by swuad_26 on 19/01/2020.
//  Copyright © 2020 swuad_19. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class DBDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // 정기결제 데이터
    // netflix 1인 9500 watch 4인 12900 tag 게임 미디어 쇼핑 음악
//    var netflix : [String : String] = ["1인":"9500","2인":"12900"]
//    var watcha : [String:String] = ["단일":"7900","4인":"12900"]
//    var tag: [String] = ["게임","미디어","쇼핑","음악"]
//    var tag: [String] = ["2020-01-25","2020-01-28"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
