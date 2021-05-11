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
    
    private var _items:[Item]!
    
    var me: User!
    var users: [User]!
    var items: [Item]! {
        get { return _items.sorted { $0.date < $1.date } }
        set(value) { _items = value }
    }
    @Published var viewStatus = ViewStatus.Login
    
    private init() {}
    
    func getUserFromUid(uid: Int64) -> User {
        return users.filter { $0.uid == uid }.first!
    }
}
