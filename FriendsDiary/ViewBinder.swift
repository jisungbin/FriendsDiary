//
//  ViewBinder.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import SwiftUI

struct ViewBinder: View {
    @ObservedObject private var vm = MainViewModel.shared
    
    var body: some View {
        if vm.viewStatus == ViewStatus.Login {
            LoginView()
        } else {
            MainView()
        }
    }
}
