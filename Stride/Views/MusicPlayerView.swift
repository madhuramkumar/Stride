//
//  MusicPlayerView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/27/23.
//

import SwiftUI

struct SongView {
    var name: String?
    var artist: String?
    var albumImage: Image
}

struct MusicPlayerView: View {
    let api = APIManager()
    var body: some View {
        @State var runStarted: Bool = false
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
                Button(action: AppState.shared.isPlaying ? api.pausePlayback: api.startPlayback, label: {
                    Image(systemName: AppState.shared.isPlaying ? "pause.circle.fill": "play.circle.fill").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
                
                Button(action: api.skipToNext, label: {
                    Image(systemName: "arrow.right.circle").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
                    .offset(x: 30)
            }
            Button(action: {
                if runStarted {
                    api.pausePlayback()
                    AppState.shared.runComplete = true
                } else {
                    runStarted = true
                    api.startPlayback()
                }
            }) {
                Text(runStarted ? "Stop Run": "Start Run")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .background(runStarted ? Color.red: Color.green )
                    .cornerRadius(25)
                    .offset(y: 40)
            }
            .offset(y: 10)
        }
        .offset(y: 180)
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView()
    }
}
