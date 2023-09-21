//
//  DBLocationModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/2/23.
//

import Foundation
import MapKit

struct DBLocationModel: Identifiable {
    var id = UUID()
    var city: String
    var location: String
    var latitude: Double
    var longitude: Double
    var regionCode: String

    
    init(mapItem: MKMapItem) {
        self.city = mapItem.name ?? ""
        self.location = mapItem.placemark.title ?? ""
        self.latitude = mapItem.placemark.location?.coordinate.latitude ?? 0.0
        self.longitude = mapItem.placemark.location?.coordinate.longitude ?? 0.0
        self.regionCode = mapItem.placemark.countryCode ?? ""
    }
}
