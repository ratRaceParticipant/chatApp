//
//  SingleRecentMessageViewModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 24/10/23.
//

import Foundation
@MainActor
class SingleRecentMessageViewModel: ObservableObject {
    
    @Published var userName: String = "Fetching Username...."
    @Published var recentMessageText: String = "Message"
    @Published var timeAgo: String = "22d"
    @Published var recieverData: UserModel?
    @Published var photoUrl: String?
    var userData = AuthenticationController.shared.getCurrentUser()
    
   
    
    func setData(recentMessageData: RecentMessageModel) async {
        do {
           recieverData = try await getRecieverData(recentMessageData: recentMessageData)
            self.userName = recieverData?.email ?? ""
            self.photoUrl = recieverData?.photoUrl
            self.timeAgo = recentMessageData.timeAgo
            self.recentMessageText = recentMessageData.text
        } catch let error {
            print("Error setting data: \(error)")
        }
    }
    
    func getRecieverData(recentMessageData: RecentMessageModel) async throws -> UserModel?{
        guard let currentUser = userData else {return nil}
        return try await UserManager.shared.getUser(userId: currentUser.userId == recentMessageData.fromId ? recentMessageData.toId : recentMessageData.fromId)
    }
    
   
}
