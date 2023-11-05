//
//  ContentView.swift
//  ChatApp
//
//  Created by Himanshu Karamchandani on 08/10/23.
//

import SwiftUI

struct MainView: View {
    @State var isUserLoggedin: Bool = !(AuthenticationController.shared.getCurrentUser() == nil)
    @State var currentUser: UserModel? = AuthenticationController.shared.getCurrentUser()
    var body: some View {
        if isUserLoggedin {
            AllMessageView(isUserLoggedIn: $isUserLoggedin,userModel: $currentUser)
        } else {
            LoginPageView(isUserLoggedIn: $isUserLoggedin, currentUser: $currentUser)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
