//
//  Item.swift
//  FriendsDiary
//
//  Created by Ji Sungbin on 2021/05/11.
//

import Foundation

struct Item: Codable {
    var owner: Int64
    var attachments: [String]
    var date = Date()
}
