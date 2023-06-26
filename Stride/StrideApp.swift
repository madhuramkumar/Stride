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
    @Published var runStarted: Bool = false
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
                // when app opens, check if there is an access token in the keychain
                .onAppear(perform: {
                    if (KeychainManager.standard.read(service: KeychainManager.standard.service, account: KeychainManager.standard.account, type: Auth.self) != nil) {
                        appState.oauthComplete = true
                    }
                })
                // when app closes, reset all states
                .onDisappear(perform: {
                    appState.oauthComplete = false
                    appState.inputDetailsComplete = false
                    appState.runComplete = false
                    appState.saveRunComplete = false
                })
        }
    }
}

struct ContentView: View {
    @StateObject var appState = AppState.shared
    var body: some View {
        
        // if oAuth has not been started, show Sign In
        if (appState.oauthComplete == false) {
            SignInView()
                .onOpenURL { url in
                    let callback = AuthorizationManager.authManager
                    callback.requestAccessAndRefreshTokens(url)
                }
            
        // if oAuth has already been completed, show LandingPage
        } else if (appState.inputDetailsComplete == false){
            LandingPageView()
            
        // if run details have been entered, show workout view
        } else if (appState.runComplete == false ) {
            WorkoutView()
        // if workout has been ended, allow user to save run
        } else if (appState.saveRunComplete == false) {
            SaveRunView()
            
        // if saving has been completed, go back to landing page and reset all states except false so user can start another workout if wanted
        } else {
            LandingPageView()
                .onAppear(perform: {
                    appState.inputDetailsComplete = false
                    appState.runComplete = false
                    appState.saveRunComplete = false
                })
        }
    }
}

