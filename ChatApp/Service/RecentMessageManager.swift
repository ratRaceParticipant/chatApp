//
//  RecentMessageManager.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 23/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

class RecentMessageManager {
    static let shared = RecentMessageManager()
    
    private let recentMessageCollection = Firestore.firestore().collection("recent_messages")
    
    
    private let encoder: Firestore.Encoder = {
        let encode = Firestore.Encoder()
        encode.keyEncodingStrategy = .convertToSnakeCase
        return encode
    }()
    
    private let decoder: Firestore.Decoder = {
        let decode = Firestore.Decoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        return decode
    }()
    
    func writeToRecentMessage(recentMessageModel: RecentMessageModel){
        do {
            try recentMessageCollection.document(recentMessageModel.id).setData(from: recentMessageModel, merge: true,encoder: encoder)
            print("Written success to recent message")
        } catch let error {
            print("Error in writing message: \(error)")
        }
    }
    
    func fetchAllRecentMessages(fromId: String,completionHandler: @escaping(_ recentMessages: [RecentMessageModel]) -> Void) {
        
        recentMessageCollection
            .whereFilter(Filter.orFilter([
                Filter.andFilter([
//                    Filter.whereField("to_id", isEqualTo: toId),
                    Filter.whereField("from_id", isEqualTo: fromId)
                ]),
                Filter.andFilter([
                    Filter.whereField("to_id", isEqualTo: fromId),
//                    Filter.whereField("from_id", isEqualTo: toId)
                ]),
            ]))
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error suune me recent messages: \(error.debugDescription)")
                    return
                    
                }
                var recentMessages: [RecentMessageModel] = []
//                snapshot.documents.compactMap({try? $0.data(as: MessageModel.self)})
                
                
                
                for document in snapshot.documents {
                    do {
                        let recentMessageData = try document.data(as: RecentMessageModel.self,decoder: self.decoder)

                        recentMessages.append(recentMessageData)
                        
                    } catch let error {
                        print("Error listenting to recent messages: \(error)")
                    }
                }
                recentMessages = recentMessages.sorted{ $0.timestamp > $1.timestamp }
                completionHandler(recentMessages)
            }
    }
    
    func updateRecentMessageText(recentMessageData: RecentMessageModel,messageText: String) async {
       
        let data: [String:Any] = [
            "text": messageText,
            "timestamp": Date()
        ]
        do {
          try await recentMessageCollection.document(recentMessageData.id).updateData(data)
           
        } catch let error {
            print("Error in updating recent message data: \(error)")
        }
            
    }
    
    func checkIfConvoPresent(fromId: String, toId: String) async -> RecentMessageModel?  {
        do {
            var recentMessageData: RecentMessageModel?
            let snapshot =  try await recentMessageCollection
                  .whereFilter(Filter.orFilter([
                      Filter.andFilter([
                          Filter.whereField("to_id", isEqualTo: toId),
                          Filter.whereField("from_id", isEqualTo: fromId)
                      ]),
                      Filter.andFilter([
                          Filter.whereField("to_id", isEqualTo: fromId),
                          Filter.whereField("from_id", isEqualTo: toId)
                      ]),
                  ]))
                  .getDocuments()
            
            for data in snapshot.documents {
                let recentMessage = try data.data(as: RecentMessageModel.self,decoder: self.decoder)
                recentMessageData = recentMessage
            }
            return recentMessageData
        } catch let error {
            print("Error in fetching convo: \(error)")
        }
        return nil
    }
    
    func checkIfConversationPresent(fromId: String, toId: String,completionHandler: @escaping(_ returnedRecentMessage: RecentMessageModel?) -> Void){
        recentMessageCollection
            .whereFilter(Filter.orFilter([
                Filter.andFilter([
                    Filter.whereField("to_id", isEqualTo: toId),
                    Filter.whereField("from_id", isEqualTo: fromId)
                ]),
                Filter.andFilter([
                    Filter.whereField("to_id", isEqualTo: fromId),
                    Filter.whereField("from_id", isEqualTo: toId)
                ]),
            ]))
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error suune me recent messages: \(error.debugDescription)")
                    return
                    
                }
                var recentMessageData: RecentMessageModel?
                for data in snapshot.documents {
                    do {
                        let recentMessage = try data.data(as: RecentMessageModel.self,decoder: self.decoder)
                        recentMessageData = recentMessage
                    } catch let error {
                        print("Error in fetching convo: \(error)")
                    }
                }
                
                completionHandler(recentMessageData)
            }
    }
}
