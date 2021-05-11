//
//  MainViewModel.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    static let shared = MainViewModel()
    
    var me: User!
    @Published var viewStatus = ViewStatus.Login
    
    private init() {}
}
