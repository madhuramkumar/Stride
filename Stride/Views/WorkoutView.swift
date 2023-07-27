//
//  WorkoutView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/27/23.
//
import SwiftUI
import CoreLocationUI
import CoreMotion
import MapKit
import SpotifyiOS
struct TrackDetails: Hashable, Codable {
    var name: String
    var artist: String
}
struct WorkoutView: View {
    @EnvironmentObject private var map: MapViewModel
    let api = APIManager.shared
    var body: some View {
        VStack {
            Text("Enjoy your personalized workout.")
                .font(.headline)
                .foregroundColor(Color.red)
            MapView()
                .padding()
                .frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 450)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.red, lineWidth: 4)
                )
                .environmentObject(map)
            NavBarView()
                .environmentObject(map)
            MusicPlayerView()
                .environmentObject(map)
        }
    }
}
struct MusicPlayerView: View {
    let api = APIManager.shared
    @EnvironmentObject var map: MapViewModel
    @StateObject var appState = AppState.shared
    var body: some View {
        VStack {
            Text("Track Name Loading...")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color.black)
                .padding(0.5)
            Text("Artist Name Loading...")
                .font(.subheadline)
                .fontWeight(.heavy)
                .foregroundColor(Color.gray)
            HStack {
                Button(action: api.skipToPrevious, label: {
                    Image(systemName: "arrow.left.circle").resizable()
                }).frame(width: 70, height: 70, alignment: .center).foregroundColor(Color.black.opacity(0.2))
                    .offset(x: -30)
                
                Button(action: appState.isPlaying ? api.pausePlayback: api.resumePlayback, label: {
                    Image(systemName: AppState.shared.isPlaying ? "pause.circle.fill": "play.circle.fill").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
                Button(action: api.skipToNext, label: {
                    Image(systemName: "arrow.right.circle").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
                    .offset(x: 30)
            }
            .disabled(!appState.runStarted)
            Button(action: {
                if appState.runStarted {
                    api.pausePlayback()
                    DispatchQueue.main.async {
                        map.stopRun()
                        appState.runStopped = true
                    }
                } else {
                    api.startPlayback()
                    DispatchQueue.main.async {
                        map.startRun()
                        appState.runStarted = true 
                    }
                }
            }) {
                Text(appState.runStarted ? "Stop Run": "Start Run")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .background(appState.runStarted ? Color.red: Color.green )
                    .cornerRadius(25)
                    .offset(y: 10)
            }
        }
    }
}

struct NavBarView: View {
    @EnvironmentObject var map: MapViewModel
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "speedometer").resizable()
                    .frame(width: 30, height: 30)
                Text("\(map.speed, specifier: "%.2f")")
            }
            VStack {
                Image(systemName: "figure.run").resizable()
                    .frame(width: 30, height: 30)
                Text("\(map.totalDistance, specifier: "%.2f")")
            }
            VStack {
                Image(systemName: "timer").resizable()
                    .frame(width: 30, height: 30)
                Text("\(map.hours):\(map.minutes):\(map.seconds)")
            }
        }
    }
}

struct MapView: View {
    @EnvironmentObject var map: MapViewModel
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Map(coordinateRegion: $map.region, showsUserLocation: true) // binds region variable
                    .ignoresSafeArea() // gets rid of map white space at top and bottom
                    .tint(.red) // color of location marker
                // when map view opens, location authorization automatically begins
                .onAppear(perform: {
                    map.checkIfLocationServicesIsEnabled()
                })
            }
        }
    }
}

    
struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
    

