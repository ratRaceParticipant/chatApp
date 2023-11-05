//
//  ImageDownloader.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 04/11/23.
//

import Foundation
import SwiftUI

class ImageDownloader {
    static let shared = ImageDownloader()
    
    private init() {}
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let imageData = data,
            let image = UIImage(data: imageData),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            return nil
        }
        return image
    }
    
    func downloadImage(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
           return handleResponse(data: data, response: response)
            
        } catch let error {
            throw error
        }
    }
}
