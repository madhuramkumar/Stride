//
//  SavePlaylistView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/26/23.
//
import SwiftUI

struct SavePlaylistView: View {
    let api = APIManager()
    @StateObject var appState = AppState.shared
    var body: some View {
        VStack {
            Text("Would you like to save this workout playlist to your library?")
            HStack {
                Button(action: {
                    print("playlist saved to spotify library")
                    api.createPlaylist()
                    DispatchQueue.main.async {
                        appState.savePlaylistComplete = true
                    }
                }) {
                    Text("Yes")
                        .frame(minWidth: 0, maxWidth: 200)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .background(Color.green)
                .cornerRadius(25)
            }
            
            Button(action: {
                print("playlist not saved")
                DispatchQueue.main.async {
                    appState.savePlaylistComplete = true
                }
            }) {
                Text("No")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .background(Color.red)
            .cornerRadius(25)
        }
    }
}
//struct NamePlaylistView: View {
//    var body: some View {
//
//    }
//}
struct SavePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        SavePlaylistView()
    }
}

