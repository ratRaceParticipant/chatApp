//
//  LoginPage.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 08/10/23.
//

import SwiftUI
import PhotosUI

struct LoginPageView: View {
    @Binding var isUserLoggedIn: Bool
    @StateObject var viewModel: LoginPageViewModel = LoginPageViewModel()
    @State var selectedImage: UIImage?
    @Binding var currentUser: UserModel?
    @State var isCreatingNewAccount: Bool = false
    
    @State var isLoginButtonClicked: Bool = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("", selection: $isCreatingNewAccount) {
                Text("Login")
                    .tag(false)
                Text("Create Account")
                    .tag(true)
            }
            .pickerStyle(.segmented)
            
            if isCreatingNewAccount {
                if let profilePhoto = selectedImage {
                    PhotosPicker(selection: $viewModel.userProfilePhoto,matching: .images, photoLibrary: .shared()) {
                        VStack {
                            Image(uiImage: profilePhoto)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        }
                    }
                    .onChange(of: viewModel.userProfilePhoto) { newValue in
                        Task {
                            guard let imageData = try? await newValue?.loadTransferable(type: Data.self) else { return }
                            selectedImage = UIImage(data: imageData)
                        }
                    }
                    
                   
                } else {
                    photosPicker
                }
            }
            
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
                
                .modifier(TextModifier())
            
            SecureField("Password", text: $viewModel.password)
                .modifier(TextModifier())
            
            Button {
                withAnimation {
                    isLoginButtonClicked = true
                }
               
                Task {
                   currentUser = await viewModel.actionHandler(email: viewModel.email, password: viewModel.password, isCreateNewAccount: isCreatingNewAccount, userProfilePhoto: viewModel.userProfilePhoto)
                   
                    if !viewModel.errorMessage.isEmpty {
                        isLoginButtonClicked = false
                    } else {
                        isUserLoggedIn = true
                        isLoginButtonClicked = false
                    }
                    
                    
                    
                }
                
                
            } label: {
                if isLoginButtonClicked{
                    ProgressView()
                        .frame(width: 30,height: 30)
                        .padding()
                        .background(Circle().stroke())
                        
                } else {
                    Text(isCreatingNewAccount ? "Create Acccount" : "Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
            }
            
            Text(viewModel.errorMessage)
                .foregroundColor(.red)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(isCreatingNewAccount ? "Create Account" : "Login")
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $isUserLoggedIn) {
            AllMessageView(isUserLoggedIn: $isUserLoggedIn, userModel: $currentUser)
        }
    }
    var photosPicker: some View {
        PhotosPicker(selection: $viewModel.userProfilePhoto,matching: .images, photoLibrary: .shared()) {
            VStack {
                Image(systemName: "person.circle")
                    .font(.system(size: 70))
                    .tint(.primary)
                Text("Upload Picture")
            }
        }
        .onChange(of: viewModel.userProfilePhoto) { newValue in
            Task {
                guard let imageData = try? await newValue?.loadTransferable(type: Data.self) else { return }
                selectedImage = UIImage(data: imageData)
            }
        }
    }
    
}

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginPageView(isUserLoggedIn: .constant(false),currentUser: .constant(AuthenticationController.shared.getCurrentUser()))
        }
    }
}
