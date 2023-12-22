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
class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private var cancellables: Set<AnyCancellable> = []
    static let shared = LocationService()
    @Published var location: CLLocation?
    
//    //TODO: - check
    override init() {
        super.init()
        setupLocationManager()
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        print("----------------- requestLocation -----------------")

    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        print("----------------- setupLocationManager -----------------")
    }
}

enum LocationStatus {
    case locationNotDetermined
    case locationRestricted
    case locationDenied
    case locationAuthorizedAlways
    case locationAuthorizedInUse
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) -> LocationStatus {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
            return LocationStatus.locationNotDetermined
               case .restricted:
                   print("Restricted by parental control")
            return LocationStatus.locationRestricted
               case .denied:
                   print("When user select option Dont't Allow")
            return LocationStatus.locationDenied
               case .authorizedAlways:
                   print("When user select option Change to Always Allow")
            return LocationStatus.locationAuthorizedAlways
               case .authorizedWhenInUse:
                   print("When user select option Allow While Using App or Allow Once")
                   locationManager.requestAlwaysAuthorization()
            return LocationStatus.locationAuthorizedInUse

               default:
                    return LocationStatus.locationNotDetermined
        }
    }
}
