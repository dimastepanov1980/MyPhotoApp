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
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
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
