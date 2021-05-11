//
//  MainView.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import SwiftUI
import ExytePopupView

struct MainView: View {
    @ObservedObject private var vm = MainViewModel.shared
    @State private var showSuccessToast = true
    @State private var showErrorToast = false
    @State private var toastMessage = "환영합니다 :)"
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {}) {
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                }
                .frame(width: 70, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.yellow)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                )
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottomTrailing
            ).padding(30)
        }
        .edgesIgnoringSafeArea(.all)
        .popup(isPresented: $showSuccessToast, type: .floater(), position: .bottom, animation: Animation.spring(), autohideIn: 2) {
            createBottomToast(Color.blue)
        }
        .popup(isPresented: $showErrorToast, type: .floater(), position: .bottom, animation: Animation.spring(), autohideIn: 2) {
            createBottomToast(Color.pink)
        }
    }
    
    private func createBottomToast(_ backgroundColor: Color) -> some View {
        Text(toastMessage)
            .padding(15)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
        }
    }
}
