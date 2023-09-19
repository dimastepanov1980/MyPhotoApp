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
    var regionCode: String
    var identifier: String
    
    init(mapItem: MKMapItem) {
        self.city = mapItem.placemark.locality ?? ""
        self.location = mapItem.placemark.title ?? ""
        self.regionCode = mapItem.placemark.countryCode ?? ""
        self.identifier = mapItem.placemark.region?.identifier ?? "" // Получаю координаты
    }
}
