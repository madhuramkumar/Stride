//
//  StartWorkoutView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/27/23.
//

import SwiftUI

struct StartWorkoutView: View {
    @StateObject private var api = APIManager()
    var body: some View {
        VStack {
            VStack {
                Text("Workout Details")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                Text("Enter your desired bpm and workout time. Stride will then create a personalized playlist to listen to during your workout.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding()
            }
            VStack {
                Text("The average walk is: 100 bpm")
                Text("The average run is: 170-180 bpm")
            }
            .foregroundColor(Color.red)
            
            Form {
                Section {
                    TextField("Enter your desired minimum bpm", text: $api.minBPM )
                        .keyboardType(.numberPad)
                    TextField("Enter your desired maximum bpm", text: $api.maxBPM)
                        .keyboardType(.numberPad)
                    TextField("Enter your desired workout time in minutes", text: $api.workoutTime)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        print("button pressed")
                        AppState.shared.inputDetailsComplete = true
                        api.getiPhoneDeviceID()
                        api.generateSeedGenres()
                        api.generateSeedTracks()
                        api.generateSeedArtists()
                        api.getSongRecommendations()
                    }) {
                        Text("Start Workout")
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
                .disabled(api.minBPM.isEmpty || api.maxBPM.isEmpty || api.workoutTime.isEmpty)
                
            }
            .background(Color.white)
        }
            
    }
}

struct StartWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        StartWorkoutView()
    }
}
