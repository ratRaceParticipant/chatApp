//
//  RecentMessageModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 23/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentMessageModel: Codable, Identifiable, Equatable {
    
    
    var id: String = UUID().uuidString
    let text: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
//    var username: String {
//        email.components(separatedBy: "@").first ?? email
//    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    var messageAndId: String {
        self.text + self.id
    }
//    init(text: String, fromId: String, toId: String, profileImageUrl: String, timestamp: Date) {
//        
//        self.text = text
//        self.fromId = fromId
//        self.toId = toId
//        self.profileImageUrl = profileImageUrl
//        self.timestamp = timestamp
//    }
}
