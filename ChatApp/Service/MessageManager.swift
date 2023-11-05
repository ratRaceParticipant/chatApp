//
//  MessageManager.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 22/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

class MessageManager {
    static let shared = MessageManager()
    
    private let messageCollection = Firestore.firestore().collection("message")
    
    
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
    
    
    func writeToMessage(messageModel: MessageModel) {
        
        do {
            try messageCollection.document(messageModel.id).setData(from:messageModel,encoder: encoder)
        } catch let error {
            print("Error in writing message: \(error)")
        }
        
        
    }
    
    
 
    
    func fetchMessages(fromId: String,toId: String,completionHandler: @escaping(_ messages: [MessageModel]) -> Void) {
//        let  messageModel: [MessageModel] = []
//        let snapshot =
//        try await
//        messageCollection
////            .order(by: "created_on", descending: false)
//            .whereField("to_id", isEqualTo: toId)
//            .whereField("from_id", isEqualTo: fromId)
//            .whereField("to_id", isEqualTo: fromId)
//            .whereField("from_id", isEqualTo: toId)
//            .getDocuments()
        
        messageCollection
            
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
                    print("Error suune me messages: \(error.debugDescription)")
                    return
                    
                }
                var messages: [MessageModel] = []
//                snapshot.documents.compactMap({try? $0.data(as: MessageModel.self)})
                
                
                for document in snapshot.documents {
                    do {
                        let messageData = try document.data(as: MessageModel.self,decoder: self.decoder)

                        messages.append(messageData)
                        
                    } catch let error {
                        print("Error listenting to messages: \(error)")
                    }
                }
                messages = messages.sorted{ $0.createdOn < $1.createdOn }
                completionHandler(messages)
            }
            

    }
}
