//
//  StrideApp.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/11/23.
//

import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var oauthComplete: Bool = false
    @Published var inputDetailsComplete: Bool = false
    @Published var runComplete: Bool = false
    @Published var saveRunComplete: Bool = false
    
    @Published var isPlaying: Bool = false
}

@main
struct StrideApp: App {
    @StateObject var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    if (KeychainManager.standard.read(service: KeychainManager.standard.service, account: KeychainManager.standard.account, type: Auth.self)!.refreshToken != "") {
                        appState.oauthComplete = true
                    }
                })
        }
        
    }
}

struct ContentView: View {
    @StateObject var appState = AppState.shared
    var body: some View {
        if (appState.oauthComplete == false) {
            SignInView()
                .onOpenURL { url in
                    let callback = AuthorizationManager.authManager
                    callback.requestAccessAndRefreshTokens(url)
                }
        } else if (appState.inputDetailsComplete == false){
            StartWorkoutView()
        } else if (appState.runComplete == false ) {
            MusicPlayerView()
                .onAppear(perform: {
                    APIManager.shared.getiPhoneDeviceID()
                    APIManager.shared.generateSeedGenres()
                    APIManager.shared.generateSeedTracks()
                    APIManager.shared.generateSeedArtists()
                    APIManager.shared.getSongRecommendations()
                })
        } else {
            SaveRunView()
                .onDisappear(perform: {
                    appState.inputDetailsComplete = false
                    appState.runComplete = false
                    appState.saveRunComplete = false
                })
        }
    }
}

