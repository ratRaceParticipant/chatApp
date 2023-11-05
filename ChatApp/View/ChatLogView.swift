//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 22/10/23.
//

import SwiftUI

struct ChatLogView: View {
    @State var messageText: String = ""
    @State var userModel: UserModel?
    @State var didAppear: Bool = false
    @State var recentMessageData: RecentMessageModel?
    static let bottomScroll = "Empty"
    @StateObject var viewModel = ChatLogViewModel()
    var body: some View {
        
        VStack(spacing: 0) {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        ForEach(viewModel.messageModel) { data in
                            VStack(alignment: .trailing) {
                                Text(data.messageText)
                                    .foregroundColor(data.toId != userModel?.userId ?? "" ? .black : .white)
                                    .padding()
                                    .background(
                                        data.toId != userModel?.userId ?? "" ? Color.white : Color.accentColor
                                    )
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity,alignment: data.toId != userModel?.userId ?? "" ? .leading : .trailing)
                            .padding(data.toId != userModel?.userId ?? "" ? .leading : .trailing)
                        }
                        HStack {Spacer()}
                            .id(Self.bottomScroll)
                    }
//                    .onReceive(viewModel.$fetchMessageCalledCount, perform: { _ in
//                        proxy.scrollTo(Self.bottomScroll,anchor: .bottom)
//                    })
                    .onChange(of: viewModel.messageModel.count) { newValue in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            proxy.scrollTo(Self.bottomScroll,anchor: .bottom)
                        }
                    }
                   
                }
                
                
            }
            
            .background(
                Image("chatBg")
                    .resizable()
                    .scaledToFill()
            )
            .clipped()

            bottomTextField
        }
        .onAppear{
              
            Task {
                if let recentMessageData = recentMessageData {
                    userModel =  await viewModel.getRecieverData(recentMessageData: recentMessageData)
                }
                
                if !didAppear {
                    viewModel.fetchMessages(
                    fromId: viewModel.currentUser?.userId ?? "",
                    toId: userModel?.userId ?? ""
                   )
                    didAppear = true
                }
            }
            
  
        }
            .navigationTitle(userModel?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
            
    }
    var bottomTextField: some View {
        Rectangle()
            
            .frame(height: 50)
            .foregroundColor(Color("messageTextField"))
            
            .overlay {
                HStack {
                    Image(systemName: "photo.fill")
                        
                    TextField("Type Message", text: $messageText)
                    Button {
                        
                        viewModel.sendMessage(toId: userModel?.userId ?? "", messageText: messageText)
                        
                        messageText = ""
                    } label: {
                        Text("SEND")
                            .font(.footnote)
                    }
                    
                    .buttonStyle(.borderedProminent)

                }
                .padding(.horizontal)
            }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatLogView(userModel:
                            UserModel(
                                userId: "xsD6rq4ssgaqGUD7LXRyF0zDIT52",
                                      email: "himanshu@fifth.com",
                                      photoUrl: "https://firebasestorage.googleapis.com:443/v0/b/fir-learning-6d9a9.appspot.com/o/xsD6rq4ssgaqGUD7LXRyF0zDIT52?alt=media&token=e66eab74-a188-4b72-92f2-7ab7f077b5d3"
                            )
            )
        }
        .preferredColorScheme(.dark)
    }
    
}
