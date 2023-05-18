//
//  SpotifyAuthorization.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/14/23.
//

import SwiftUI
import Foundation
import SpotifyiOS

class SpotifyAPI {
    let clientID = "YOUR_CLIENT_ID"
    let clientSecret = "YOUR_CLIENT_SECRET"
    let redirectURI = "Stride://"
    let state = String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))
    let scope = "user-read-private user-read-email"
    @Published var authorizationCode = "";
    
    func authorize(completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL with parameters
        var urlComponents = URLComponents(string: "https://accounts.spotify.com/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "scope", value: scope),
        ]
        let url = urlComponents.url!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func handleCallBackURL() {
        
//        // Verify that the state value matches the value you provided in the authorization request
//        let currentState = extractState(from: url)
//        if (state != currentState) {
//            print("Invalid callback URL: \(url.absoluteString)")
//            return
//
//        } else {
//
//            // Store the authorization code for use in subsequent requests
//            authorizationCode = extractCode(url)
//        }

    }
    
//    func handleResult(_ result: Result<Data, Error>) {
//        switch result {
//        case .success(let data):
//            // Access the data here
//            print("Data: \(data)")
//            // Perform any further processing or decoding of the data
//            url = data
//
//        case .failure(let error):
//            // Handle the error case
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//
    func extractCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let codeItem = queryItems.first(where: { $0.name == "code" }) else {
            return nil
        }
        
        return codeItem.value
    }
    
    func extractState(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let stateItem = queryItems.first(where: { $0.name == "state" }) else {
            return nil
        }
        
        return stateItem.value
    }
}



                                        
                        
