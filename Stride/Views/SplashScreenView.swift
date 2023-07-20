//
//  SplashScreenView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 7/19/23.
//

import SwiftUI

struct SplashScreenView: View {
    var appState = AppState.shared
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.black)
            VStack {
                Text("Stride")
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .font(.system(size: 100))
                Image(systemName: "music.note.list").resizable()
                    .foregroundColor(Color.white)
                    .frame(width: 100, height: 100)
            }
            .offset(y: -100)
            VStack {
                Text("Music that matches you.")
                    .foregroundColor(Color.white)
                    .font(.subheadline)
            }
            .offset(y: 100)
        }
        .onAppear(perform: {
            if (KeychainManager.standard.read(service: KeychainManager.standard.service, account: KeychainManager.standard.account, type: Auth.self) != nil) {
                appState.oauthComplete = true
                if (AuthorizationManager.authManager.isTokenExpired()) {
                    AuthorizationManager.authManager.refreshAuthentication()
                } else {
                    AuthorizationManager.authManager.token = KeychainManager.standard.read(service: KeychainManager.standard.service, account: KeychainManager.standard.account, type: Auth.self)!.accessToken
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    appState.isActive = true
                }
            }
        })
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
