//
//  MainView.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import SwiftUI
import ExytePopupView

struct MainView: View {
    @State private var showSuccessToast = true
    @State private var showErrorToast = false
    @State private var toastMessage = "환영합니다 :)"
    
    var body: some View {
        ZStack {
            Color.pink
        }
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
