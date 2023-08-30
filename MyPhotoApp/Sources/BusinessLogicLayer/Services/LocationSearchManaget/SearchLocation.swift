//
//  SearchLocation.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/30/23.
//

import SwiftUI

import Foundation
import MapKit
import Combine

struct SearchLocation: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter City", text: $viewModel.cityText)
            Divider()
            
            Text("Results")
                .font(.title)
            List(viewModel.viewData) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text(item.subtitle)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct SerchLocation_Previews: PreviewProvider {
    static var previews: some View {
        SearchLocation()
    }
}




struct LocalSearchViewData: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
    }
}

@MainActor
final class ContentViewModel: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var cityText = "" {
        didSet {
            searchForCity(text: cityText)
        }
    }
    
    @Published var viewData = [LocalSearchViewData]()

    var service: SearchLocationManaget
    
    init() {
//        New York
        let center = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
        service = SearchLocationManaget(in: center)
        
        cancellable = service.searchLocationPublisher.sink { mapItems in
            self.viewData = mapItems.map({ LocalSearchViewData(mapItem: $0) })
        }
    }
    
    private func searchForCity(text: String) {
        service.searchLocation(searchText: text)
    }
}
