//
//  CacheImageView.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 05/11/23.
//

import SwiftUI
import CachedAsyncImage
struct CacheImageView: View {
    @State var photoUrl: String
    @State var showProgressPlaceholder: Bool = true
    var body: some View {
        CachedAsyncImage(
            url: URL(string : photoUrl),
            urlCache:
                URLCache.imageCache
        ) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 40,height: 40)
                .clipShape(Circle())
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                )
        } placeholder: {
            if showProgressPlaceholder {
                ProgressView()
            } else {
                Image(systemName: "person.fill")
            }
        }
    }
    
}

struct CacheImageView_Previews: PreviewProvider {
    static var previews: some View {
        CacheImageView(photoUrl: "https://firebasestorage.googleapis.com:443/v0/b/fir-learning-6d9a9.appspot.com/o/xsD6rq4ssgaqGUD7LXRyF0zDIT52?alt=media&token=e66eab74-a188-4b72-92f2-7ab7f077b5d3")
    }
}
