//
//  CustomerMainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/18/23.
//

import Foundation

@MainActor
protocol CustomerMainScreenViewModelType: ObservableObject {
    var portfolio: [AuthorPortfolioModel] { get }
    var selectedItem: AuthorPortfolioModel? { get set }
    var imagesURLs: [URL]? { get set }
    var showDetailScreen: Bool { get set }
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String
    func imagePathToURL(imagePath: [String]) async throws
}
