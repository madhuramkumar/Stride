//
//  AuthorizationManager.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/14/23.
//

import SwiftUI
import Foundation
//import SpotifyiOS

enum AuthConstants {
    static let clientID = "YOUR_CLIENT_ID"
    static let clientSecret = "YOUR_CLIENT_SECRET"
    static let redirectURI = "Stride://"
    static let state = String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))
    static let scope = "user-read-private user-read-email app-remote-control streaming playlist-read-private playlist-modify-private playlist-modify-public user-library-modify user-top-read"
}

struct RefreshToken: Codable, Hashable {
    var refresh_token: String
}

struct AccessToken: Codable, Hashable {
    var access_token: String
    var token_type: String
    var scope: String
    var expires_in: Int
}

class AuthorizationManager: ObservableObject {
    
    static let authManager = AuthorizationManager()
    var refreshToken: RefreshToken? = nil
    var accessToken: AccessToken? = nil

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
        
        // opens url to allow user to give authorization to access Spotify info
        UIApplication.shared.open(url, options: [:])
    }
    
    func requestAccessAndRefreshTokens(_ url: URL) {
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
            guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
                print("Invalid URL")
                return
            }
            
            // Create URL Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST" // method
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // header
            let base64encoded = "Basic \((AuthConstants.clientID + ":" + AuthConstants.clientSecret).data(using: .utf8)!.base64EncodedString())"  // base 64 encode the client ID and the client secret
            request.addValue(base64encoded, forHTTPHeaderField: "Authorization") // header
            var bodyComponents = URLComponents()
            bodyComponents.queryItems = [// body
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: authCode),
                URLQueryItem(name: "redirect_uri", value: AuthConstants.redirectURI)
            ]
            request.httpBody = bodyComponents.query?.data(using: .utf8)
            
            // Make POST Request
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("got dataString: \n\(dataString)")
                    }
                }
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
            
                // assigns response JSON to AccessDetails struct
                guard let access = try? JSONDecoder().decode(AccessToken.self, from: data) else {
                    print("Error Decoding Access Details from JSON")
                    return
                }
                
                self.accessToken = access
                
                // puts refresh token in seperate struct
                guard let refresh = try? JSONDecoder().decode(RefreshToken.self, from: data) else {
                    print("Error Decoding Refresh Token from JSON")
                    return
                }
                        
                self.refreshToken = refresh
                print("refresh token is \(String(describing: self.refreshToken))")
            }
            task.resume()
        }
    }
    
    // must be called before an hour passes, as access token only lasts for one hour
    func refreshAuthentication() {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // method
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // header
        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [// body
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken?.refresh_token)
        ]
        request.httpBody = bodyComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("got dataString: \n\(dataString)")
                }
            }
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
        
            // assigns response JSON to AccessDetails struct
            guard let access = try? JSONDecoder().decode(AccessToken.self, from: data) else {
                print("Error Decoding JSON")
                return
            }
            
            self.accessToken = access
            
        }
        task.resume()
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



                                        
                        
