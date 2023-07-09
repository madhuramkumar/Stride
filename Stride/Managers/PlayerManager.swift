////
////  PlayerManager.swift
////  Stride
////
////  Created by Madhu Ramkumar on 7/4/23.
////
//
//import Foundation
//import SpotifyiOS
//import Combine
//
//struct Track {
//    var name: String
//    var artist: String
//}
//
//class SpotifyController: NSObject, ObservableObject {
//
//
//    let auth = AuthorizationManager.authManager
//    @Published var trackDetails: Track?
//
//    private var connectCancellable: AnyCancellable?
//    private var disconnectCancellable: AnyCancellable?
//
//    override init() {
//        super.init()
//        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                self.connect()
//            }
//
//        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                self.disconnect()
//            }
//
//    }
//
//    lazy var configuration = SPTConfiguration(
//        clientID: AuthConstants.clientID,
//        redirectURL: URL(string: "Stride://")!
//    )
//
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
//        appRemote.connectionParameters.accessToken = auth.token
//        appRemote.delegate = self
//        return appRemote
//    }() // IS THIS CORRECT?
//
//    func connect() {
//        appRemote.connect()
//    }
//
//    func disconnect() {
//        if appRemote.isConnected {
//            appRemote.disconnect()
//        }
//    }
//
//}
//
//extension SpotifyController: SPTAppRemoteDelegate {
//
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        self.appRemote = appRemote
//        self.appRemote.playerAPI?.delegate = self
//        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//            }
//
//        })
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        print("failed")
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        print("disconnected")
//    }
//}
//
//extension SpotifyController: SPTAppRemotePlayerStateDelegate {
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        trackDetails?.name = playerState.track.name
//        trackDetails?.artist = playerState.track.artist.name
//    }
//}
//
//
//
//
//
