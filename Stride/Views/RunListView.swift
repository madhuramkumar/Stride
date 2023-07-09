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
        VStack {
            VStack {
                Text(workout.name)
                    .font(.largeTitle)
                    .padding()
                HStack {
                    Text(DateFormatter().string(from: workout.date))
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    Text("[BPMS OF RUN]")
                }
                
            }.offset(y: -150)
            VStack {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 300, height: 300)
            }.offset(y: -120)
            HStack {
                VStack {
                    Image(systemName: "speedometer")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("[X MINUTE PER MILE]")
                }
                VStack {
                    Image(systemName: "mappin")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("[DISTANCE]")
                }
                VStack {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("[TOTAL TIME]")
                }
            }
            // playlistInfo
        }
    }
}
struct RunRowView: View {
    let workout: Workout
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.name)
                Text("Distance: " + workout.distance + "miles")
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(DateFormatter().string(from: workout.date))
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

