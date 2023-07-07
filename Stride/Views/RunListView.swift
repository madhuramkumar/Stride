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
    
    var runs: [RunDetails] = [
        RunDetails(id: "Easy Run", date: Date(), averagePace: 0.0, distance: 0.0, time: 0.0, averageBPM: 150.0),
        RunDetails(id: "Medium Run", date: Date(), averagePace: 0.0, distance: 0.0, time: 0.0, averageBPM: 150.0),
        RunDetails(id: "Hard Run", date: Date(), averagePace: 0.0, distance: 0.0, time: 0.0, averageBPM: 150.0)
    ]
    
    var body: some View {
        NavigationView {
            List(runs) { run in
                NavigationLink {
                    RunDetailsView(run: run)
                } label : {
                    RunRowView(run: run)
                    
                }.navigationTitle("Run Log")
            }.multilineTextAlignment(.center)
        }
    }
}

struct RunDetailsView: View {
    var run: RunDetails
    var body: some View {
        VStack {
            VStack {
                Text(run.id)
                    .font(.largeTitle)
                    .padding()
                HStack {
                    Text(DateFormatter().string(from: run.date))
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
                        .frame(width: 50, height: 50)
                    Text("[X MINUTE PER MILE]")
                }
                VStack {
                    Image(systemName: "mappin")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("[DISTANCE]")
                }
                VStack {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("[TOTAL TIME]")
                }
            }
            // playlistInfo
        }
    }
}

struct RunRowView: View {
    var run: RunDetails
    var body: some View {
        HStack {
            Text(run.id)
            Spacer()
            Text(DateFormatter().string(from: run.date))
                .foregroundColor(Color.gray)
        }
    }
}
struct RunListView_Previews: PreviewProvider {
    static var previews: some View {
        RunListView()
    }
}

