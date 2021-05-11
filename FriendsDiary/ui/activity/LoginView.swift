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

struct LoginView: View {
    @State private var showSuccessToast = false
    @State private var showErrorToast = false
    @State private var toastMessage = ""
    private let vm = MainViewModel.shared
    
    var body: some View {
        VStack {
            Button(action: {
                login()
            }) {
                Text("카카오 로그인으로 시작하기")
                    .padding()
                    .font(.custom("MunhwajaeDolbom-Regular", size: 20))
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.yellow)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
            }
        }
        .onOpenURL(perform: { url in
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        })
        
    }
    
    private func login() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    showErrorToast.toggle()
                    toastMessage = error.localizedDescription
                    print(error)
                } else {
                    getMe()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    showErrorToast.toggle()
                    toastMessage = error.localizedDescription
                    print(error)
                }
                else {
                    getMe()
                }
            }
        }
    }
    
    private func getMe() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                showErrorToast.toggle()
                toastMessage = error.localizedDescription
                print(error)
            } else {
                showSuccessToast.toggle()
                toastMessage = "환영합니다 :)"
                print("AAA")
                
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            LoginView()
        }
    }
}
