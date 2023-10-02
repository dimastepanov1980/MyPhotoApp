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
    private var portfolioCache: [String: [AuthorPortfolioModel]] = [:]

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
    @Published var selectedDate: Date = Date()

    
    init() {
        searchService = SearchLocationManager(in: CLLocationCoordinate2D())
        cancellable = searchService.searchLocationPublisher.sink { [weak self] mapItems in
            self?.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
        }
    }
    
    func getCurrentLocation() {
        if let currentLocation = searchService.getCurrentLocation() {
            self.latitude = currentLocation.latitude
            self.longitude = currentLocation.longitude
            print("New latitude \(self.latitude)")
            print("New longitude \(self.longitude)")
        }
    }

    func getPortfolio(longitude: Double, latitude: Double, date: Date) async throws -> [AuthorPortfolioModel] {
        do {
            print("Selected date in function getPortfolio \(date)")
            return try await UserManager.shared.getPortfolioForCoordinateAndDate(longitude: longitude, latitude: latitude, startEventDate: date).map{ AuthorPortfolioModel(portfolio: $0) }
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

