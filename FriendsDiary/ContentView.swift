//
//  ContentView.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/10.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser
import Firebase

struct ContentView: View {
    var body: some View {
        VStack {
            Text("FriendsDiary")
                .font(.system(size: 30, weight: .bold, design: .default))
            Button(action : {
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("loginWithKakaoTalk() success.")
                            _ = oauthToken
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("loginWithKakaoAccount() success.")
                            UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    let uid = user?.id
                                    let name = user?.kakaoAccount?.profile?.nickname
                                    let profileImageUrl = user?.kakaoAccount?.profile?.profileImageUrl
                                    let user = User(uid: uid!, name: name!, profileImageUrl: (profileImageUrl ?? URL(string: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")!).absoluteString)
                                    
                                    Firestore.firestore().collection("users").document(String(user.uid)).setData([
                                        "uid": user.uid,
                                        "name": user.name,
                                        "profileImageUrl": user.profileImageUrl
                                    ])
                                }
                            }
                        }
                    }
                }
            }){
                Text("카카오 로그인으로 시작하기")
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .shadow(color: .gray, radius: 10)
                    )
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            }
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
