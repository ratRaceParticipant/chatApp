//
//  SingleRecentMessageView.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 24/10/23.
//

import SwiftUI
@MainActor
struct SingleRecentMessageView: View {
    @State var recentMessageData: RecentMessageModel
    @StateObject var viewModel: SingleRecentMessageViewModel = SingleRecentMessageViewModel()
    @ObservedObject var allMessageViewModel: AllMessageViewModel
    var body: some View {
        HStack {
            if let url = viewModel.photoUrl {
                CacheImageView(photoUrl: url)
            } else {
                Image(systemName: "person.fill")
                    .font(.title)
            }
            VStack(alignment: .leading) {
                Text(viewModel.userName)
                Text(recentMessageData.text)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(recentMessageData.timeAgo)
                
                .font(.footnote)
                .foregroundColor(.secondary.opacity(0.7))
        }
//        .padding(.horizontal)
        
        .onChange(of: allMessageViewModel.recentMessage, perform: { newValue in
            Task {
               
                await viewModel.setData(recentMessageData: recentMessageData)
                
            }

        })
        .onAppear{
            Task {
                await viewModel.setData(recentMessageData: recentMessageData)
                
            }
        }
    }
}

//struct SingleRecentMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleRecentMessageView(recentMessageData: RecentMessageModel(text: "Text", fromId: "me", toId: "you", profileImageUrl: "", timestamp: Date()))
//    }
//}
