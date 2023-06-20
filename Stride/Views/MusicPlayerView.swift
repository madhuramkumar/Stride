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
    @State var isPlaying: Bool = false;
    let api = APICalls()
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
                Button(action: api.startPlayback, label: {
                    Image(systemName: isPlaying ? "pause.circle.fill": "play.circle.fill").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
                
                Button(action: api.skipToNext, label: {
                    Image(systemName: "arrow.right.circle").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
                    .offset(x: 30)
            }
        }
        .offset(y: 160)
    
    }
}

struct MusicPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView()
    }
}
