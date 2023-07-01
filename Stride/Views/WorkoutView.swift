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

struct SongView {
    var name: String?
    var artist: String?
    var albumImage: Image
}

struct WorkoutView: View {
    var body: some View {
        VStack {
            MapView()
                .padding()
                .frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 450)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 4)
                )
            MusicPlayerView()
        }
    }
}

struct MusicPlayerView: View {
    let api = APIManager.shared
    @StateObject var appState = AppState.shared
    var body: some View {
        VStack {
            Text("Song Name")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color.black)
                .padding(0.5)
            Text("Song Artist")
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
                        appState.runStopped = true
                    }
                } else {
                    api.startPlayback()
                    DispatchQueue.main.async {
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

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true) // binds region variable
                .ignoresSafeArea() // gets rid of map white space at top and bottom
                .tint(.red) // color of location marker

            // when map view opens, location authorization automatically begins
            .onAppear(perform: {
                viewModel.checkIfLocationServicesIsEnabled()
            })
            Text(String(describing: viewModel.speed))

        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
