//
//  MessageModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 22/10/23.
//

import Foundation
import Firebase

struct MessageModel: Codable, Identifiable {
    let id: String
    var fromId: String
    var toId: String
    var messageText: String
    var createdOn: Date
    
    init(fromId: String, toId: String,messageText: String) {
        self.id = UUID().uuidString
        self.fromId = fromId
        self.toId = toId
        self.createdOn = Date()
        self.messageText = messageText
    }
}
