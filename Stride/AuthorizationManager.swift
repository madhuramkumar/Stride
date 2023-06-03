//
//  AuthorizationManager.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/14/23.
//

import SwiftUI
import Foundation
import SpotifyiOS

enum AuthConstants {
    static let clientID = "YOUR_CLIENT_ID"
    static let clientSecret = "YOUR_CLIENT_SECRET"
    static let redirectURI = "Stride://"
    static let state = String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))
    static let scope = "user-read-private user-read-email app-remote-control streaming playlist-read-private playlist-modify-public user-library-modify"
}

struct AccessDetails: Codable {
    var access_token: String
    var token_type: String
    var scope: String
    var expires_in: Int
    var refresh_token: String
}

class AuthorizationManager: ObservableObject {

    func authorize() {
        // Define the URL with parameters
        var urlComponents = URLComponents(string: "https://accounts.spotify.com/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConstants.clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: AuthConstants.redirectURI), // page in app that you go back to after authorization
            URLQueryItem(name: "state", value: AuthConstants.state), // check to makes sure that data hasn't been tampered with
            URLQueryItem(name: "scope", value: AuthConstants.scope), // different scopes allow access to different endpoints
            URLQueryItem(name: "show_dialog", value: "true") // always requires user to accept terms box
        ]
        // creates url from components
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }
    
        UIApplication.shared.open(url, options: [:])
    }
    
    func handleCallBackURL(_ url: URL) {
        let authCode = extractCode(from: url)
        let currentState = extractState(from: url)
        if (authCode == nil) { // complete error handling here
            print("User authorization failed.")
        }
        
        if (currentState != AuthConstants.state) { // checks that states match to make sure app hasnt been tampered with
            print ("States do not match. authorization stopped.")
            // stop the authorization flow
            return // check this
        } else {
            // create URL
            guard let url = URL(string: "https://accounts.spotify.com/token") else {
                print("Invalid URL")
                return
            }
            
            // Create URL Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST" // method
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // header
            let base64encoded = "\(AuthConstants.clientID):\(AuthConstants.clientSecret)".data(using: .isoLatin1)?.base64EncodedString() ?? ""  // base 64 encode the client ID and the client secret
            request.addValue("Basic \(base64encoded)", forHTTPHeaderField: "Authorization") // header
            let body: [String: AnyHashable] = [ // body
                "grant_type": "authorization_code",
                "code": authCode,
                "redirect_uri": AuthConstants.redirectURI
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            
            // Make POST Request
            let task = URLSession.shared.dataTask(with: request) {data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(AccessDetails.self, from: data) // store values in AccessDetails struct
                    print("SUCCESS: \(response)")
                }
                catch {
                    print(error)
                }
            }
            task.resume()
        }
    }

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



                                        
                        
