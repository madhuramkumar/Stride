//
//  SaveRunView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 7/7/23.
//
import SwiftUI
struct SaveRunView: View {
    @EnvironmentObject private var store: Store
    @StateObject var appState = AppState.shared
    @State private var nameText: String = ""
    @State private var distanceText: String = ""
    @State private var dateField: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name your workout!", text: $nameText)
                TextField("Distance", text: $distanceText)
                DatePicker(selection: $dateField, displayedComponents: .date) {
                    Text("Date")
                }
            }
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    let workout = Workout(
                        name: self.nameText,
                        distance: self.distanceText,
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

