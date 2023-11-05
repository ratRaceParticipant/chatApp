//
//  ChatLogViewModel.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 22/10/23.
//

import Foundation
@MainActor
class ChatLogViewModel: ObservableObject {
    @Published var fetchMessageCalledCount = 0
    @Published var messageModel: [MessageModel] = []
    let currentUser = AuthenticationController.shared.getCurrentUser()
    
   
    
    func sendMessage(toId: String, messageText: String){
        
        guard let user = currentUser else {
            print("Recent message write failed")
            return
            
        }
        
        let messageModel = MessageModel(fromId: user.userId, toId: toId, messageText: messageText)
        
        MessageManager.shared.writeToMessage(messageModel: messageModel)
        
        Task {
            print("Recent message called")
            let returnedMessageData = await RecentMessageManager.shared.checkIfConvoPresent(fromId: user.userId, toId: toId)

            if !(returnedMessageData?.id.isEmpty ?? true), let data = returnedMessageData {
               
            print("Recent message Updated")
               await RecentMessageManager.shared.updateRecentMessageText(recentMessageData: data, messageText: messageText)
              
            } else {
                
                let recentMessage = 
                
                RecentMessageModel(text: messageModel.messageText, fromId: messageModel.fromId, toId: messageModel.toId, profileImageUrl: "", timestamp: messageModel.createdOn)
                RecentMessageManager.shared.writeToRecentMessage(recentMessageModel: recentMessage)
                
                print("New Reecent message added!!!")
            }
            
            self.fetchMessageCalledCount += 1
        }
        

    }
    
    func fetchMessages(fromId: String, toId: String) {
        
        
        DispatchQueue.main.async {
            MessageManager.shared.fetchMessages(fromId: fromId, toId: toId) { [weak self] messages in
                self?.messageModel = messages
                
                self?.fetchMessageCalledCount += 1
            }
            
            
        }
        
    }
    func getRecieverData(recentMessageData: RecentMessageModel) async -> UserModel?{
        do {
            guard let currentUser = currentUser else {return nil}
            return try await UserManager.shared.getUser(userId: currentUser.userId == recentMessageData.fromId ? recentMessageData.toId : recentMessageData.fromId)
        } catch let error{
            print("Error in getting reciever data: \(error.localizedDescription)")
        }
        return nil
    }
    
   
}
