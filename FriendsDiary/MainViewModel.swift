//
//  MainViewModel.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import Foundation

class MainViewModel {
    static let shared = MainViewModel()
    
    var me: User!
    var viewStatus = ViewStatus.Login
    
    private init() {}
}
