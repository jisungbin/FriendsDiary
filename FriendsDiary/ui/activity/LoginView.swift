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
import ExytePopupView

struct LoginView: View {
    @ObservedObject private var vm = MainViewModel.shared
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                Text("FriendsDiary")
                    .font(.custom("MunhwajaeDolbom-Regular", size: 30))
                Image("ic_launcher")
                    .resizable()
                    .frame(width: 170, height: 170)
                    .padding(.top, 30)
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            ).padding(.top, 100)
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
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottom
            ).padding(.bottom, 100)
        }
        .edgesIgnoringSafeArea(.all)
        .popup(isPresented: $showToast, type: .floater(), position: .bottom, animation: Animation.spring(), autohideIn: 2) {
            createBottomToast()
        }
        .onOpenURL(perform: { url in
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        })
    }
    
    private func createBottomToast() -> some View {
        Text(toastMessage)
            .padding(15)
            .background(Color.pink)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
    
    private func login() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    showToast.toggle()
                    toastMessage = error.localizedDescription
                    print(error)
                } else {
                    getMe()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    showToast.toggle()
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
                showToast.toggle()
                toastMessage = error.localizedDescription
                print(error)
            } else {
                let uid = user?.id
                let name = user?.kakaoAccount?.profile?.nickname
                let profileImageUrl = user?.kakaoAccount?.profile?.profileImageUrl
                let user = User(uid: uid!, name: name!, profileImageUrl: (profileImageUrl ?? URL(string: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")!).absoluteString)
                
                let doc = Firestore.firestore().collection("users").document(String(user.uid))
                doc.getDocument { (document, error) in
                    if !document!.exists {
                        doc.setData([
                            "uid": user.uid,
                            "name": user.name,
                            "profileImageUrl": user.profileImageUrl
                        ])
                    }
                }
                
                vm.me = user
                vm.viewStatus = ViewStatus.Main
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
    }
}
