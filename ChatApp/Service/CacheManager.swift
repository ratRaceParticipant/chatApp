//
//  CacheManager.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 04/11/23.
//

import Foundation
import SwiftUI
class CacheManager {
    static let shared = CacheManager()
    
    private init () {}
    
    var profileImageCache: NSCache<NSString, UIImage> {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 1
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }
    var profileImageURL: NSCache<NSString, NSString> {
        let cache = NSCache<NSString, NSString>()
        cache.countLimit = 1
        return cache
    }
    
//    func addProfileImageToCache(imageUrl: String, profileImage: UIImage) {
//        profileImageCache.setObject(profileImage, forKey: "profileImage" as NSString)
//        profileImageURL.setObject(imageUrl as NSString, forKey: "profileImageURL" as NSString)
//        
//        
//        
//    }
    
//    func getProfileImageFromCache() -> UIImage{
//        let imageURL = profileImageURL.object(forKey: "profileImageURL" as NSString)
//        let profileImage = profileImageCache.object(forKey: "profileImage" as NSString)
//        
//        guard let img = profileImage else {
//            print("SOMETHING IS NULL...")
//            print("PHOTO URL: \(imageURL ?? "")")
//            return(UIImage())
//            
//        }
//        return img
//        
//    }
    
}
