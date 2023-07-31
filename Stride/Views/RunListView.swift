//
//  RunListView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/21/23.
//
import SwiftUI
import CoreData
import MapKit

struct RunDetails: Hashable, Codable, Identifiable {
    var id: String
    var date: Date
    var averagePace: Double
    var distance: Double
    var time: Double
    var averageBPM: Double
//    var mapImage: MKMapSnapshotter.Snapshot
}

func dateFormat(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    dateFormatter.locale = .init(identifier: "en_GB")
    return dateFormatter.string(from: date)
}

struct RunListView: View {
    @EnvironmentObject var store: Store
    @State private var isAddingMode: Bool = false
    var body: some View {
        NavigationView {
            ListView()
                .navigationTitle("Workout Log")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        TrailingView()
                    }
                }
        }
    }
}

struct ListView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        List {
            ForEach (store.state.workouts) { item in
                NavigationLink {
                    RunDetailsView(workout: item)
                } label: {
                    RunRowView(workout: item)
                }
            }
            .onDelete {
                store.dispatch(action: .removeWorkout(at: $0))
            }
            .listRowInsets(EdgeInsets())
        }
    }
}

struct RunDetailsView: View {
    let workout: Workout
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(workout.name)
                    .font(.largeTitle)
                HStack {
                    Text(dateFormat(workout.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(workout.averageBPM) BPM")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Image(systemName: "photo")
                .resizable()
                .background(Color.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.vertical, 20)

            HStack(spacing: 30) {
                RunStatView(imageName: "speedometer", value: formatNumericValue(workout.speed), unit: "mins/mile")
                RunStatView(imageName: "mappin", value: formatNumericValue(workout.distance), unit: "miles")
                RunStatView(imageName: "timer", value: "\(workout.timeHrs):\(workout.timeMins):\(workout.timeSecs)", unit: "time")
            }
            
            // playlistInfo
        }
        .padding()
    }
}

// Helper function to format numeric values with two decimal places
func formatNumericValue(_ value: Double) -> String {
    return String(format: "%.2f", value)
}

struct RunStatView: View {
    let imageName: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
            Text(value)
                .font(.headline)
            if !unit.isEmpty {
                Text(unit)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct RunRowView: View {
    let workout: Workout
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.name)
                Text("Distance: \(workout.distance, specifier: "%.2f") miles")
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(dateFormat(workout.date))
            }
        }
        .padding()
    }
}

struct TrailingView: View {
    @EnvironmentObject var store: Store
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            Button(action: {
                switch self.store.state.sortType {
                case .distance:
                    self.store.dispatch(action: .sort(by: .distance))
                default:
                    self.store.dispatch(action: .sort(by: .date))
                }
            }) {
                Image(systemName: "arrow.up.arrow.down")
            }
            EditButton()
        }
    }
}
struct RunListView_Previews: PreviewProvider {
    static var previews: some View {
        RunListView()
    }
}

