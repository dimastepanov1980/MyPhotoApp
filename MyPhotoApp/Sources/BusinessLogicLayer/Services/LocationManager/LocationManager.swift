//
//  LocationManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/25/23.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class LocationViewModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func requestLocation() async throws {
        try await locationManager.requestWhenInUseAuthorization()
        try await locationManager.requestLocation()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}

/*
 
 import CoreLocation

 class YourViewModelClass {
     private let locationManager = CLLocationManager()

     // Function to fetch the location and store it in cache (UserDefaults)
     func fetchLocationAndSaveToCache() {
         locationManager.delegate = self
         locationManager.requestWhenInUseAuthorization()
         locationManager.requestLocation()
     }

     // Function to fetch weather based on the saved location from cache
     func fetchWeatherFromCache() {
         // Fetch the saved location from cache (UserDefaults or CoreData)
         if let cachedLocation = loadLocationFromCache() {
             // Use the cached location to fetch the weather
             do {
                 try fetchWeather(lat: cachedLocation.latitude, lon: cachedLocation.longitude, exclude: "hourly")
             } catch {
                 // Handle error
             }
         } else {
             // Location not available in cache, handle accordingly
         }
     }

     // Function to load the saved location from cache (UserDefaults or CoreData)
     private func loadLocationFromCache() -> CLLocationCoordinate2D? {
         let defaults = UserDefaults.standard
         if let latitude = defaults.value(forKey: "cachedLatitude") as? Double,
            let longitude = defaults.value(forKey: "cachedLongitude") as? Double {
             return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
         }
         return nil
     }

     // Function to save the location in cache (UserDefaults or CoreData)
     private func saveLocationToCache(_ location: CLLocationCoordinate2D) {
         let defaults = UserDefaults.standard
         defaults.set(location.latitude, forKey: "cachedLatitude")
         defaults.set(location.longitude, forKey: "cachedLongitude")
     }

     // Your existing fetchWeather function remains the same...
 }

 // CLLocationManagerDelegate extension to handle location updates
 extension YourViewModelClass: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.first else { return }
         saveLocationToCache(location.coordinate)
     }

     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         // Handle location fetch error, if any
     }
 }

 */
