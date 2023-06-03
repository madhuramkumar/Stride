//
//  WorkoutSession.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/2/23.
//

import Foundation
import HealthKit
import SwiftUI

struct WorkoutDetails {
    var minBPM: Int // user input
    var maxBPM: Int // user input
    var averageBPM: Int // user input
    var genres: [String] // user input
    var seedArtists: String // generated based on user inputted bpm
    var seedTracks: String // generated based on user inputted bpm
}

class WorkoutSession: NSObject, ObservableObject {

    func initializeWorkoutDetails() {
        
    }
    
    // generate seed artists for recommendation based on user inputted bpm
    func generateSeedArtists() {
        
    }
    
    // generate seed tracks based on user inputted bpm
    func generateSeedTracks() {
        
    }
    
    // find song according to bpm, and genres
    func findSong() {
        
    }
    
    // create a new playlist in which songs from the workout will be added to
    func createPlaylist() {
        
    }
    
    // add song to playlist
    func addSongToPlaylist() {
        
    }
    
    // music starts playing
    func startWorkout() {
        
    }
    
    // music stops playing, playlist is added to library, and workout details are shown (implemented later)
    func endWorkout() {
        
    }

}
