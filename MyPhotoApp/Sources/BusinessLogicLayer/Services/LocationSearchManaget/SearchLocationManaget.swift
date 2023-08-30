//
//  SearchLocationManaget.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/30/23.
//

import Foundation
import MapKit
import Combine

@MainActor
final class SearchLocationManaget {
    let searchLocationPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let center: CLLocationCoordinate2D
    private let radius: CLLocationDistance

    init(in center: CLLocationCoordinate2D,
         radius: CLLocationDistance = 350_000) {
        self.center = center
        self.radius = radius
    }
    
    public func searchLocation(searchText: String) {
        requestLocation(resultType: .address, searchText: searchText)
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
