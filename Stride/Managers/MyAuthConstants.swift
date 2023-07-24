//
//  MyAuthConstants.swift
//  Stride
//
//  Created by Madhu Ramkumar on 7/24/23.
//

import Foundation

enum MyAuthConstants {
    static let clientID = "YOUR_CLIENT_ID"
    static let clientSecret = "YOUR_CLIENT_SECRET"
    static let redirectURI = "YOUR_REDIRECT_URI"
    static let state = String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))
    static let scope = "user-read-private user-read-email app-remote-control streaming playlist-read-private playlist-modify-private playlist-modify-public user-library-modify user-top-read user-read-playback-state user-modify-playback-state" // add any other scopes you would like to access here
}
