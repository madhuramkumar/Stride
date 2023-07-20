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
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var allSpeeds: [Double] = []
    
    // run info
    @Published var totalDistance = 0.0
    @Published var isRunning = false
    @Published var averageSpeed = 0.0
    
    // timer info
    @Published var timer: Timer? = nil
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    var locationManager : CLLocationManager? // anything to do with user location goes through CLLLocationManager
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert prompting them to go to settings and turn this on.")
        }
    }
    
    func lineView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .blue
      renderer.lineWidth = 3.0
      return renderer
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
        
        if isRunning {
            if self.startLocation == nil {
                self.startLocation = locations.first!
            } else {
                let lastLocation = locations.last!
                let distance = self.startLocation.distance(from: lastLocation)
                self.startLocation = lastLocation
                self.totalDistance += self.distanceToMiles(distance)
            }
        }
    
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let myLocation = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        // updated our region. since its a published variable, its UI changes will be monitored
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: myLocation, span: span)
            self.speed = self.speedToMinutesPerMile(latestLocation.speed)
            self.allSpeeds.append(self.speed)
        }
    }

    func calcAverageSpeed() {
        var arraySum = self.allSpeeds.reduce(0, +)
        var length = self.allSpeeds.count
        var average = Double(arraySum)/Double(length)
        averageSpeed = roundTo(average)
    }
    
    func speedToMinutesPerMile(_ speed: Double) -> Double {
        return speed / 26.82
    }
    
    func distanceToMiles(_ distance: Double) -> Double {
        return distance * 0.000621371
    }
    
    func roundTo(_ num: Double) -> Double {
        return (num * 100) / 100.0
    }
    
    func startRun() {
        isRunning = true;
        startTimer()
    }
    
    func stopRun() {
        isRunning = false;
        stopTimer()
        calcAverageSpeed()
    }
    
    func startTimer() {
        // 1. Make a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
          // 2. Check time to add to H:M:S
          if self.seconds == 59 {
            self.seconds = 0
            if self.minutes == 59 {
              self.minutes = 0
              self.hours = self.hours + 1
            } else {
              self.minutes = self.minutes + 1
            }
          } else {
            self.seconds = self.seconds + 1
          }
        }
    }
    
    func stopTimer() {
      timer?.invalidate()
      timer = nil
    }
    
    // prints error if location manager catches a fail
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
    
    func resetAllVariables() {
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        self.totalDistance = 0.0
        self.startLocation = nil
        self.lastLocation = nil
        self.isRunning = false
    }
}

