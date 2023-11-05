//
//  UserManager.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 08/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore




class UserManager {
    static let shared = UserManager()
    private init () {}
    
    
    
    private let userCollection = Firestore.firestore().collection("user")
    
    
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
    
    
    func writeToUser(user: UserModel) {
         
        do {
           try userCollection.document(user.userId).setData(from: user,encoder: encoder)
        } catch let error {
            print("Error in writing data to user collection: \(error)")
        }
        
    }
    
    func getUser(userId: String) async throws -> UserModel {
        
        
        return try await userCollection.document(userId).getDocument(as: UserModel.self,decoder: decoder)
       
    }
    
    func updateUserData(DBUser: UserModel) throws {
       
          try userCollection.document(DBUser.userId).setData(from: DBUser, merge: true, encoder: encoder)
        
    }
    
    func getUsersWithEmail() async throws -> [UserModel] {
        var userModel: [UserModel] = []
        let snapshot = try await
        userCollection
            .order(by: "email")
//            .start(at: [emailSearchText])
//            .end(at: [emailSearchText])
//            .whereField("email", arrayContains: emailSearchText)
//            .whereField("email", isGreaterThanOrEqualTo: emailSearchText)
//            .whereField("email", isLessThan: emailSearchText + "z")
            .getDocuments()
        for document in snapshot.documents {
            let user = try document.data(as: UserModel.self,decoder: decoder)
            
           
                userModel.append(user)
            
  
        }
        
        return userModel
    }
}
