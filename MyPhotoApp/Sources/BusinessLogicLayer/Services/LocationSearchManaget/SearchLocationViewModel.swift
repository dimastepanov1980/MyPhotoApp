//
//  SearchLocationViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/2/23.
//

import Foundation
import Combine
import MapKit

//@MainActor
/* final class SearchLocationViewModel: ObservableObject {
    
    private var cancellable: AnyCancellable?
    
    @Published var locationAuthor = "" {
        didSet {
            searchForCity(text: locationAuthor)
        }
    }
    @Published var locationResult = [DBLocationModel]()
    @Published var resultCity = ""
    
    var service = SearchLocationManaget()

    
    init() {
        cancellable = service.searchLocationPublisher.sink { mapItems in
            self.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
        }
    }
    
    private func searchForCity(text: String) {
        service.searchLocation(searchText: text)
    }
} */
