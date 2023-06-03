//
//  APICalls.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/31/23.
//

import SpotifyiOS
import Foundation
import SwiftUI

struct RecommendationSeedObject: Hashable, Codable {
    var href: String
    var id: String
}

struct TrackObject: Hashable, Codable {
    var href: String
    var id: String
}

struct Song: Hashable, Codable {
    var seeds: [RecommendationSeedObject]
    var tracks: [TrackObject]
    
}

class APICalls: ObservableObject {
    func fetchData() {
        guard let url = URL(string: "https://api.spotify.com/v1/recommendations") else {
            return
        }
    }
}
