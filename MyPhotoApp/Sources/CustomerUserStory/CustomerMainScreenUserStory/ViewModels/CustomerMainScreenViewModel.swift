//
//  CustomerMainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/21/23.
//

import Foundation
import SwiftUI
import Combine
import MapKit
import PhotosUI

@MainActor
final class CustomerMainScreenViewModel: CustomerMainScreenViewModelType, ObservableObject {
    
    var searchService: SearchLocationManager
    private var cancellable: AnyCancellable?
    
    @Published var imagesURLs: [URL]? = nil
    @Published var portfolio: [AuthorPortfolioModel] = []
    @Published var selectedItem: AuthorPortfolioModel? = nil
    @Published var showDetailScreen: Bool = false
    @Published var locationResult: [DBLocationModel] = []
    @Published var locationAuthor: String = "" {
        didSet {
            searchForCity(text: locationAuthor)
        }
    }
    @Published var regionAuthor: String = ""
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    init() {
        searchService = SearchLocationManager(in: CLLocationCoordinate2D())
        cancellable = searchService.searchLocationPublisher.sink { mapItems in
            self.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
        }
            self.portfolio = []
            Task {
                do {
                    let dbPortfolio = try await getPortfolio(longitude: longitude , latitude: latitude)
                    print(latitude, longitude)
                    self.portfolio = dbPortfolio.map { AuthorPortfolioModel(portfolio: $0) }
                    print(portfolio)
                } catch {
                    print(String(describing: error))
                }
            }
        }
    
    func getPortfolioForLocation(location: String) async throws -> [DBPortfolioModel] {
        do {
            let portfolio = try await UserManager.shared.getPortfolioLocation(location: location)
            return portfolio
        } catch {
            throw error
        }
    }
    func getPortfolio(longitude: Double , latitude: Double) async throws -> [DBPortfolioModel] {
        do {
            let portfolio = try await UserManager.shared.getPortfolioCoordinateRange(longitude: longitude, latitude: latitude)
            return portfolio
        } catch {
            throw error
        }
    }
    func stringToURL(imageString: String) -> URL? {
        guard let imageURL = URL(string: imageString) else { return nil }
        return imageURL
    }
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
    func imagePathToURL(imagePath: [String]) async throws {
        for path in imagePath {
           let imageURL = try await StorageManager.shared.getImageURL(path: path)
            imagesURLs?.append(imageURL)
        }
    }
    private func searchForCity(text: String) {
        searchService.searchLocation(searchText: text)
    }
}
