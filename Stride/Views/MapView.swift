//
//  MapView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/31/23.
//

import CoreLocationUI
import HealthKit
import CoreMotion
import MapKit
import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true) // binds region variable
                .ignoresSafeArea() // gets rid of map white space at top and bottom
                .tint(.red) // color of location marker
            
            // when map view opens, location authorization automatically begins
            .onAppear(perform: {
                viewModel.checkIfLocationServicesIsEnabled()
            })
            Text(String(describing: viewModel.speed))
                
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }

}
