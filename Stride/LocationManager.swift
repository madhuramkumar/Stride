//
//  LocationManager.swift
//  Stride
//
//  Created by Madhu Ramkumar on 6/1/23.
//

import Foundation
import CoreLocationUI
import CoreMotion
import MapKit
import SwiftUI

// enum to store the default map
enum mapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

// class that aids in map view, showing user location on map
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: mapDetails.startingLocation, span: mapDetails.defaultSpan) // how zoomed out you want map to be
    @Published var speed = 0.0
//    let lineCoordinates: [CLLocation]
//    let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
    
    var locationManager : CLLocationManager? // anything to do with user location goes through CLLLocationManager
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert prompting them to go to settings and turn this on.")
        }
    }
    
    // deals with different LocationAuthorization cases
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    // called first time user gives authorization (first use of app) and everytime user changes authorization status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // [CLLLocation] is array of locations that holds a route of path of the user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            // return error
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let myLocation = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)

        // updated our region. since its a published variable, its UI changes will be monitored
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: myLocation, span: span)
            self.speed = latestLocation.speed
        }
    }
    
    // prints error if location manager catches a fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
    
}





