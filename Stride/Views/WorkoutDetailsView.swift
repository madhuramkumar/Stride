//
//  WorkoutDetailsView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/27/23.
//
import SwiftUI
struct WorkoutDetailsView: View {
    @StateObject private var api = APIManager.shared
    @StateObject var appState = AppState.shared
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
                    TextField("Enter your desired minimum bpm", text: $api.minBPM)
                        .keyboardType(.numberPad)
                    TextField("Enter your desired maximum bpm", text: $api.maxBPM)
                        .keyboardType(.numberPad)
                    TextField("Enter your desired workout time in minutes", text: $api.workoutTime)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        print("button pressed")
                        api.resetAllVariables() // make sure that state is reset
                        api.gatherData() // func that generates seed artists, tracks, and genres as well as recommendations
                        appState.inputDetailsComplete = true
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
struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
            WorkoutDetailsView()
    }
}

