//
//  SaveRunView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 7/7/23.
//
import SwiftUI
struct SaveRunView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var map: MapViewModel
    @StateObject var appState = AppState.shared
    @State private var nameText: String = ""
    @State private var distanceField: Double = 0.0
    @State private var dateField: Date = Date()
    @State private var hoursField: Int = 0
    @State private var minutesField: Int = 0
    @State private var secondsField: Int = 0
    @State private var speedField: Double = 0.0
    
    var body: some View {
        NavigationView {
            Form {
                LabeledContent {
                  TextField("Name your workout!", text: $nameText)
                } label: {
                  Text("Name")
                        .bold()
                }
                LabeledContent {
                    TextField("miles", value: $distanceField, format: .number )
                        .onAppear(perform: {
                            distanceField = map.totalDistance
                        })
                        .keyboardType(.numberPad)
                } label: {
                    Text("Distance (miles)")
                        .bold()
                }
                LabeledContent {
                    HStack {
                        LabeledContent {
                            TextField("Hours", value: $hoursField, format: .number)
                                .onAppear(perform: {
                                    hoursField = map.hours
                                })
                                .keyboardType(.numberPad)
                        } label : {
                            Text("hrs")
                        }
                        LabeledContent {
                            TextField("Minutes", value: $minutesField, format: .number)
                                .onAppear(perform: {
                                    minutesField = map.minutes
                                })
                                .keyboardType(.numberPad)
                        } label: {
                            Text("mins")
                        }
                        LabeledContent {
                            TextField("Seconds", value: $secondsField, format: .number)
                                .onAppear(perform: {
                                    secondsField = map.seconds
                                })
                                .keyboardType(.numberPad)
                        } label: {
                            Text("sec")
                        }
                    }
                } label: {
                    Text("Time")
                        .bold()
                }
                LabeledContent {
                    TextField("mins / mile", value: $speedField, format: .number)
                        .onAppear(perform: {
                            speedField = map.averageSpeed
                        })
                        .keyboardType(.numberPad)
                } label: {
                    Text("Speed (mins / mile)")
                        .bold()
                }
                DatePicker(selection: $dateField, displayedComponents: .date) {
                    Text("Date")
                        .bold()
                }
            }
            .navigationTitle(nameText)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    let workout = Workout(
                        name: self.nameText,
                        distance: self.distanceField,
                        timeHrs: self.hoursField,
                        timeMins: self.minutesField,
                        timeSecs: self.secondsField,
                        speed: self.speedField,
                        averageBPM:  APIManager.shared.calcAverageBPM(),
                        date: self.dateField
                    )
                    store.dispatch(action: .addWorkout(workout))
                    DispatchQueue.main.async {
                        appState.saveRunComplete = true
                    }
                }) {
                    Text("Save Run")
                }
                .disabled(nameText.isEmpty)
            )
        }
    }
}
struct SaveRunView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunView()
    }
}

