//
//  AllMessageView.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 15/10/23.
//

import SwiftUI
import UIKit
import CachedAsyncImage
@MainActor
struct AllMessageView: View {
    @Binding var isUserLoggedIn: Bool
    @State var showActionSheet: Bool = false
    @Binding var userModel: UserModel?
    @StateObject var viewModel = AllMessageViewModel()
   
    var body: some View {
        
            ZStack(alignment: .bottomTrailing) {
                if viewModel.recentMessage.isEmpty {
                    VStack {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("No Chats available!")
                            
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                } else {
                    List {
                        ForEach(viewModel.recentMessage, id: \.messageAndId) { data in
                            NavigationLink {
                                ChatLogView(recentMessageData: data)
                            } label: {
                                SingleRecentMessageView(recentMessageData: data, allMessageViewModel: viewModel)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                NavigationLink {
                    NewMessageView()
                } label: {
                        Image(systemName: "plus")
                            .tint(.white)
                            .padding()
                            .background(Color.accentColor)
                            .clipShape(Circle())
                }
                .padding()
            }
            
            .onAppear{
                
                Task {
                
                    viewModel.fetchRecentMessages(fromId: userModel?.userId ?? "")
                    
                    viewModel.photoURL = await viewModel.getUserPhotoUrl(userId: userModel?.userId ?? "")
                    print("PHOT URLLL !!! \(viewModel.photoURL ?? "NO URL")")
//                    
//                    if let url = viewModel.photoURL {
//                        viewModel.profileImage = await viewModel.downloadImage(urlString: url)
//                        
//                    }
                    
                }
                
            }
            .listStyle(.plain)
                .toolbar(content: {
                    ToolbarItem {
                        Button {
                            showActionSheet = true
                        } label: {
                            Image(systemName: "gear")
                        }
                        .confirmationDialog("Setings", isPresented: $showActionSheet) {
                            Button(role: .destructive) {
                                try? AuthenticationController.shared.logOut()
                                
                                showActionSheet = false
                                isUserLoggedIn = false
                            } label: {
                                Text("Sign Out")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        HStack {
                            if let url = viewModel.photoURL {
                                CacheImageView(photoUrl: url,showProgressPlaceholder: false)
                            } else{
                                Image(systemName: "person.fill")
                            }
                        }
                    }
                })
                .navigationTitle("Chats")
                .navigationBarTitleDisplayMode(.large)
        }
    
}

//struct AllMessageView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        NavigationStack {
//            AllMessageView(isUserLoggedIn: .constant(true),userModel: .constant(AuthenticationController.shared.getCurrentUser()))
//        }
//    }
//}
