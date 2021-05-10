//
//  AppDelegate.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/10.
//

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        KakaoSDKCommon.initSDK(appKey: "3dec89acaf5e4025a1c5763500a88c41")
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           if (AuthApi.isKakaoTalkLoginUrl(url)) {
               return AuthController.handleOpenUrl(url: url, options: options)
           }
           return false
       }
}
