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
    var location: String
    var regionCode: String
    
    init(mapItem: MKMapItem) {
        self.location = mapItem.placemark.title ?? ""
        self.regionCode = mapItem.placemark.countryCode ?? ""
    }
}
