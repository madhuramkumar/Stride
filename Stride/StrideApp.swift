//
//  StrideApp.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/11/23.
//
import SwiftUI
class AppState: ObservableObject {
    static let shared = AppState()
    let defaults = UserDefaults.standard
    @Published var oauthComplete: Bool = false
    @Published var inputDetailsComplete: Bool = false
    @Published var runStarted: Bool = false
    @Published var runStopped: Bool = false
    @Published var savePlaylistComplete: Bool = false
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
                        if (AuthorizationManager.authManager.isTokenExpired()) {
                            AuthorizationManager.authManager.refreshAuthentication()
                        } else {
                            AuthorizationManager.authManager.token = KeychainManager.standard.read(service: KeychainManager.standard.service, account: KeychainManager.standard.account, type: Auth.self)!.accessToken
                        }
                    }
                })
                // when app closes, reset all states
                .onDisappear(perform: {
                    appState.oauthComplete = false
                    appState.inputDetailsComplete = false
                    appState.runStopped = false
                    appState.savePlaylistComplete = false
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
        } else if (appState.runStopped == false ) {
            WorkoutView()
        // if workout has been ended, allow user to save run
        } else if (appState.savePlaylistComplete == false) {
            SavePlaylistView()
        // if saving has been completed, go back to landing page and reset all states except false so user can start another workout if wanted
        } else if (appState.saveRunComplete == false) {
            SaveRunView()
                .environmentObject(Store.shared)
        } else {
            LandingPageView()
                .onAppear(perform: {
                    appState.inputDetailsComplete = false
                    appState.runStarted = false
                    appState.runStopped = false
                    appState.savePlaylistComplete = false
                    appState.saveRunComplete = false
                    appState.isPlaying = false
                    APIManager.shared.resetAllVariables()
                })
        }
    }
}


