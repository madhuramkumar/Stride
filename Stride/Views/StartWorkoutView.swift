//
//  StartWorkoutView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/27/23.
//

import SwiftUI

struct StartWorkoutView: View {
    @StateObject private var api = APICalls()
    var body: some View {
        VStack {
            VStack {
                Text("Workout Details")
                    .offset(y: -80)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                Text("Enter your desired bpm and workout time. Stride will then create a personalized playlist to listen to during your workout.")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .offset(y: -80)
                    .padding()
            }
            VStack {
                Text("The average walk is: 100 bpm")
                Text("The average run is: 170-180 bpm")
            }
                .offset(y: -50)
                .foregroundColor(Color.red)
            HStack {
                Text("Enter your desired minimum bpm")
                    .padding()
                    .offset(x: 20)
                TextField("Enter here", text: $api.minBPM)
                    .keyboardType(.numberPad)
                    .offset(x: 80)
            }
            HStack {
                Text("Enter your desired maximum bpm")
                    .padding()
                    .offset(x: 20)
                TextField("Enter here", text: $api.maxBPM)
                    .keyboardType(.numberPad)
                    .offset(x: 80)
            }
            
            HStack {
                Text("Enter your desired workout time")
                    .padding()
                    .offset(x: 20)
                TextField("Enter here", text: $api.workoutTime)
                    .keyboardType(.numberPad)
                    .offset(x: 80)
            }

            Button(action: {
                print("button pressed")
//                api.getAvailableDevices()
                api.startPlayback()
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
            .offset(y: 60)
        }
    }
}

struct StartWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        StartWorkoutView()
    }
}
