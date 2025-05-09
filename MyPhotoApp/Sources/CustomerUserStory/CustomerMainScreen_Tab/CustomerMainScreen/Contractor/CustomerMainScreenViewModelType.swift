//
//  CustomerMainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/18/23.
//

import Foundation

@MainActor
protocol CustomerMainScreenViewModelType: ObservableObject {
    var portfolio: [AuthorPortfolioModel] { get set }
    var imagesURLs: [URL]? { get set }
    var showDetailScreen: Bool { get set }
    var locationResult: [DBLocationModel] { get set }
    var locationAuthor: String { get set }
    var regionAuthor: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var selectedDate: Date { get set }
    var userProfileIsSet: Bool { get set }
    var showAlertPortfolio: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }

    func fetchPortfolio(longitude: Double, latitude: Double, date: Date) async throws -> [AuthorPortfolioModel]
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String
    func imagePathToURL(imagePath: [String]) async throws
    func getPortfolioForDate(date: Date) async throws -> [AuthorPortfolioModel]
    func getPortfolioForLocation(longitude: Double, latitude: Double, date: Date) async throws -> [AuthorPortfolioModel]
    func getCurrentLocation()
}
