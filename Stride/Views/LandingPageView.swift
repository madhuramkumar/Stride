//
//  LandingPageView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/26/23.
//
import SwiftUI
struct LandingPageView: View {
    var body: some View {
        TabView {
            WorkoutDetailsView()
                .tabItem {
                    Label("Start Run", systemImage: "figure.run.circle")
                }
            RunListView()
                .tabItem {
                    Label("Run Log", systemImage: "list.bullet")
                }
                .environmentObject(Store.shared)
        }
    }
}
struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}


