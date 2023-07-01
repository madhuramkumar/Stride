//
//  APIManager.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/31/23.
//

//import SpotifyiOS
import Foundation
import SwiftUI


struct RecommendationSeedObject: Codable, Hashable {
    var href: String
    var id: String
}

struct Song: Codable, Hashable {
    var seeds: [RecommendationSeedObject]
    var tracks: [TrackObject]
}

struct TrackObject: Codable, Hashable {
    var href: String
    var id: String
    var duration_ms: Int
    var name: String
    var artists: [ArtistObject]
}

struct ArtistObject: Codable, Hashable {
    var href: String
    var id: String
    var name: String
}

struct UserTopArtists: Codable {
    var href: String
    var items: [ArtistObject]
}

struct UserTopTracks: Codable {
    var href: String
    var items: [TrackObject]
}

struct Genres: Codable {
    var genres: [String]
}

struct Recommendations: Codable {
    var tracks: [TrackObject]
}

struct UserInfo: Codable {
    var id: String
    
}

struct DeviceObject: Hashable, Codable {
    var id: String
    var is_active: Bool
    var is_restricted: Bool
    var type: String
}

struct Devices: Hashable, Codable {
    var devices: [DeviceObject]
}

struct Error: Hashable, Codable {
    var status: Int
    var message: String
}

enum RecommendationSeeds {
    static let seedGenres = "work-out, club"
}

struct PlaybackState: Hashable, Codable  {
    var progress_ms: Int
    var item: [TrackObject]
}

class APIManager: ObservableObject {
    static let shared = APIManager()
    let auth = AuthorizationManager.authManager
    
    // updated in StartWorkoutView
    @Published var minBPM = ""
    @Published var maxBPM = ""
    @Published var workoutTime = ""
    @Published var track: [TrackObject] = []
    
    // gathered from user data, generated by getTop endpoint
    var seedArtists: String = ""
    var seedTracks: String = ""
    var recommendedTracks: [String] = []
    
    // for playback
    var deviceID: String = ""
    var userID: String = ""
    var playbackState: PlaybackState?
    
    // for when only endpoint is in url
    func fetchAPI(_ endpoint: String, _ method: String) -> URLRequest {
        
        if (auth.isTokenExpired()) {
            auth.refreshAuthentication()
        }
        
        let url = URL(string: "https://api.spotify.com/v1/\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        let token = "Bearer " + auth.token
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    // for when url query items needs to be used
    func fetchAPI(_ url: URL, _ method: String) -> URLRequest {
        
        if (auth.isTokenExpired()) {
            auth.refreshAuthentication()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Bearer \(auth.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func getUserID() {
        let request = fetchAPI("me", "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse {
                    if (response.statusCode == 200) {
                          // assigns response JSON to UserTopArtists struct
                        guard let user = try? JSONDecoder().decode(UserInfo.self, from: data) else {
                            print("Error Decoding Top Track Details from JSON")
                            return
                        }
                        UserDefaults.standard.set(user.id, forKey: "userID")
                        self.userID = user.id
                        return
                    } else {
                        guard let errorInfo = try? JSONDecoder().decode(Error.self, from: data) else {
                            print("Error decoding error message details from JSON")
                            return
                        }
                        print (errorInfo.message)
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
        }
        task.resume()
    }
    
    func getiPhoneDeviceID() {
        let request = fetchAPI("me/player/devices", "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                // print out data for debugging purposes
                if let dataString = String(data: data, encoding: .utf8) {
                    print("got dataString: \n\(dataString)")
                }
                
                // handle response
                if let response = response as? HTTPURLResponse {
                    if (response.statusCode == 200) {
                        // assigns response JSON to UserTopArtists struct
                        guard let devices = try? JSONDecoder().decode(Devices.self, from: data) else {
                            print("Error Decoding Device Details from JSON")
                            return
                        }
                        // only get the deviceID of the iPhone
                        for device in devices.devices {
                            if device.type == "Computer" {
                                UserDefaults.standard.set(device.id, forKey: "deviceID")
                                self.deviceID = device.id
                                return
                            }
                        }
                        // if smartphone not active, DEAL WITH THIS LATER
                        print ("Could not find smartphone in list of available devices")
                    } else {
                        guard let errorInfo = try? JSONDecoder().decode(Error.self, from: data) else {
                            print("Error decoding error message details from JSON")
                            return
                        }
                        print (errorInfo.message)
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
    
    // generates seed artists for getRecommendations endpoint based on users top artists
    func generateSeedArtists() {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/top/artists")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "limit", value: "2")
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }
        let request = fetchAPI(url, "GET")
        let task = URLSession.shared.dataTask(with: request ) { data, response, error in

            // print out data for debugging purposes
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("got dataString: \n\(dataString)")
                }
            }
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let response = response as? HTTPURLResponse {
                if (response.statusCode == 200) {
                    // assigns response JSON to UserTopArtists struct
                    guard let topArtists = try? JSONDecoder().decode(UserTopArtists.self, from: data) else {
                        print("Error Decoding Top Artist Details from JSON")
                        return
                    }
                    self.convertSeedArtistsToString(topArtists.items)
                } else {
                    guard let errorInfo = try? JSONDecoder().decode(Error.self, from: data) else {
                        print("Error decoding error message details from JSON")
                        return
                    }
                    print (errorInfo.message)
                }
            }
        }
        task.resume()
    }

    // helper function to put JSON into a string
    func convertSeedArtistsToString(_ artists: [ArtistObject]) {
        for seed in artists {
            seedArtists += seed.id + ","
        }
    }

    // generates seed tracks for getRecommendations endpoint based on users top tracks
    func generateSeedTracks() {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/top/artists")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "limit", value: "1")
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }
        let request = fetchAPI(url, "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // print out data for debugging purposes
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("got dataString: \n\(dataString)")
                }
            }

            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let response = response as? HTTPURLResponse {
                if (response.statusCode == 200) {
                    // assigns response JSON to UserTopArtists struct
                    guard let topTracks = try? JSONDecoder().decode(UserTopTracks.self, from: data) else {
                        print("Error Decoding Top Track Details from JSON")
                        return
                    }
                    self.convertSeedTracksToString(topTracks.items)
                } else {
                    guard let errorInfo = try? JSONDecoder().decode(Error.self, from: data) else {
                        print("Error decoding error message details from JSON")
                        return
                    }
                    print (errorInfo.message)
                }
            }
        }
        task.resume()
    }

    // helper function to put JSON into a string
    func convertSeedTracksToString(_ tracks: [TrackObject]) {
        for seed in tracks {
            seedTracks += seed.id + ","
        }
    }

    func numSongs() -> Double {
        if (workoutTime == "") {
            fatalError("workout time did not initialize!!")
        }

        let num = round(Double(workoutTime)! / 3.5)
        if num <= 100 {
            return num
        } else {
            print("maximum songs exceeded. REMEMBER TO DEAL WITH THIS CASE.")
            return 100.0
        }
    }

    func getSongRecommendations() {
        // create URL for API request
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/recommendations")!
        urlComponents.queryItems = [// body
//            URLQueryItem(name: "limit", value: String(numSongs())),
            URLQueryItem(name: "seed_artists", value: seedArtists),
            URLQueryItem(name: "seed_genres", value: RecommendationSeeds.seedGenres),
            URLQueryItem(name: "seed_tracks", value: seedTracks),
            URLQueryItem(name: "min_tempo", value: minBPM),
            URLQueryItem(name: "max_tempo", value: maxBPM)
        ]
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }

        // create API Request
        let request = fetchAPI(url, "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // print out data for debugging purposes
            if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    print("got dataString: \n\(dataString)")
                }
            }

            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let response = response as? HTTPURLResponse {
                if (response.statusCode == 200) {
                    // assigns response JSON to UserTopArtists struct
                    guard let recommendations = try? JSONDecoder().decode(Recommendations.self, from: data) else {
                        print("Error Decoding Recommendation Details from JSON")
                        return
                    }
                    self.convertRecommendedTracksToArray(recommendations.tracks)
                } else {
                    guard let errorInfo = try? JSONDecoder().decode(Error.self, from: data) else {
                        print("Error decoding error message details from JSON")
                        return
                    }
                    print (errorInfo.message)
                }
            }
        }
        task.resume()
    }

    func convertRecommendedTracksToArray(_ recTracks: [TrackObject]) {
        for seed in recTracks {
            recommendedTracks.append("spotify:track:\(seed.id)")
        }
    }

    // PLAYBACK FUNCTIONS
    func startPlayback() {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/player/play")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "device_id", value: deviceID), // might cause problems, check
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }

        // create API Request
        var request = fetchAPI(url, "PUT")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["uris": recommendedTracks, "position_ms": 0] // might cause problems, check
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            print("Playback started.")
            DispatchQueue.main.async {
                AppState.shared.isPlaying = true
            }
        }
        task.resume()
    }

    func pausePlayback() {
        let deviceID = UserDefaults.standard.string(forKey: "deviceID")
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/player/pause")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "device_id", value: deviceID),
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }

        // create API Request
        let request = fetchAPI(url, "PUT")
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            print("playback paused")
            DispatchQueue.main.async {
                AppState.shared.isPlaying = false
            }
        }
        task.resume()
    }

    func resumePlayback() {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/player/play")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "device_id", value: deviceID),
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }
        // create API Request
        let request = fetchAPI(url, "PUT")
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            print("Playback resumed.")
            DispatchQueue.main.async {
                AppState.shared.isPlaying = true
            }
        }
        task.resume()
    }
    
    
    func skipToPrevious() {
        let deviceID = UserDefaults.standard.string(forKey: "deviceID")
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/player/previous")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "device_id", value: deviceID),
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }

        // create API Request
        let request = fetchAPI(url, "POST")
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            print("skip to previous")
        }
        task.resume()
    }

    func skipToNext() {
        let deviceID = UserDefaults.standard.string(forKey: "deviceID")
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/me/player/next")!
        urlComponents.queryItems = [// body
            URLQueryItem(name: "device_id", value: deviceID),
        ] // have to supply the iphone device id, otherwise it wont play
        guard let url = urlComponents.url else {
            fatalError("Missing URL!")
        }

        // create API Request
        let request = fetchAPI(url, "POST")
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            print("skip to next")
        }
        task.resume()
    }


    // can be used to make progress bar / scrubber
    func getPlaybackState() {
        let request = fetchAPI("me/player", "GET")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                
                // print out data for debugging purposes
                if let dataString = String(data: data, encoding: .utf8) {
                    print("got dataString: \n\(dataString)")
                }
                
                if let response = response as? HTTPURLResponse {
                    if (response.statusCode == 200) {
                        // assigns response JSON to UserTopArtists struct
                        guard let state = try? JSONDecoder().decode(PlaybackState.self, from: data) else {
                            print("Error Decoding Playback State Details from JSON")
                            return
                        }
                        self.playbackState = state
                    } else {
                        guard let errorInfo = try? JSONDecoder().decode(Error.self, from: data) else {
                            print("Error decoding error message details from JSON")
                            return
                        }
                        print (errorInfo.message)
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
        }
        task.resume()
    }

    // create playlist of recommended songs whose length = specified workout time
    func createPlaylist() {


    }
    
    func gatherData() {
        if(UserDefaults.standard.string(forKey: "deviceID") == nil) {
            getiPhoneDeviceID()
        } else {
            deviceID = UserDefaults.standard.string(forKey: "deviceID")!
        }
        
        if(UserDefaults.standard.string(forKey: "userID") == nil) {
            getUserID()
        } else {
            userID = UserDefaults.standard.string(forKey: "userID")!
        }
        
        generateSeedTracks()
        generateSeedArtists()
        getSongRecommendations()
    }
}
