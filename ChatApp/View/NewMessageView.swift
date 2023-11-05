//
//  NewMessageView.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 21/10/23.
//

import SwiftUI
import CachedAsyncImage
struct NewMessageView: View {
    @State var searchText: String = ""
    @StateObject var viewModel = NewMessageViewModel()
    var body: some View {
        Group {
            if viewModel.userModel.isEmpty {
                if searchText.isEmpty {
                    Text("Search For Users.")
                } else if !viewModel.anyUserFound {
                    Text("No User Found")
                } else {
                    ProgressView()
                }
            } else {
                List {
                    ForEach(viewModel.userModel) { data in
                        NavigationLink {
                            ChatLogView(userModel: data)
                        } label: {
                            HStack(spacing: 15) {
                                if let photoUrl = data.photoUrl {
                                    
                                    CacheImageView(photoUrl: photoUrl)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 30))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(data.email ?? "")
                                }
                               
                            }
                            .padding()
                        }

                    }
                }
                .listStyle(.inset)
                
            }
        }
        .searchable(text: $searchText,prompt: "Search User")
        .onAppear{
            Task {
                await viewModel.getAllUsers()
            }
        }
        .onChange(of: searchText, perform: { searchable in
            viewModel.searchUser(searchText: searchable)
        })
        .navigationTitle("New Message")
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewMessageView()
        }
    }
}
