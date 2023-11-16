//
//  SearchLocationManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/30/23.
//

import Foundation
import MapKit
import Combine

@MainActor
final class SearchLocationManager: NSObject, CLLocationManagerDelegate {
    let searchLocationPublisher = PassthroughSubject<[MKMapItem], Never>()
    private var locationManager = CLLocationManager()
    private let center: CLLocationCoordinate2D
    private let radius: CLLocationDistance
    private var currentCoordinate: CLLocationCoordinate2D?
    private var searchTimer: Timer?
    private let searchDelay: TimeInterval = 0.7 // Adjust the delay time as needed
    
    init(in center: CLLocationCoordinate2D, radius: CLLocationDistance = .infinity) {
        self.center = center
        self.radius = radius
    }
    
    func searchLocation(searchText: String) {
        // Invalidate the previous timer, if any
        searchTimer?.invalidate()

        // Start a new timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            Task {
                await self.requestLocation(resultType: [.pointOfInterest, .address], searchText: searchText)
            }
        }
    }

    
    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
        currentCoordinate = coordinate
    }
    
    private func requestLocation(resultType: MKLocalSearch.ResultType = .address, searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        request.region = MKCoordinateRegion(center: center,
                                           latitudinalMeters: radius,
                                           longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }
            self?.searchLocationPublisher.send(response.mapItems)
        }
    }
    
    func requestCurrentLocation() {
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task{
            await updateLocation(location.coordinate)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}


 final class SearchLocationManager1 {
    
    let searchLocationPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let center: CLLocationCoordinate2D
    private let radius: CLLocationDistance
    private var currentCoordinate: CLLocationCoordinate2D?
    private var searchTimer: Timer?
    private let searchDelay: TimeInterval = 0.3 // Adjust the delay time as needed
    
    init(in center: CLLocationCoordinate2D,
         radius: CLLocationDistance = .infinity) {
        self.center = center
        self.radius = radius
    }
    
    public func searchLocation(searchText: String) {
        // Invalidate the previous timer, if any
        searchTimer?.invalidate()
        
        // Start a new timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { [weak self] _ in
            self?.requestLocation(resultType: [.pointOfInterest, .address], searchText: searchText)
        }
    }
    
    func updateLocation(_ coordinate: CLLocationCoordinate2D) {
            currentCoordinate = coordinate
        }
    
    private func requestLocation(resultType: MKLocalSearch.ResultType = .address, searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        request.region = MKCoordinateRegion(center: center,
                                           latitudinalMeters: radius,
                                           longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }
            self?.searchLocationPublisher.send(response.mapItems)
        }
    }
}
 



