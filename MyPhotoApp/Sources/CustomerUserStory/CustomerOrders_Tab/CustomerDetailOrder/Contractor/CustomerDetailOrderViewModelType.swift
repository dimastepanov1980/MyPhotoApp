//
//  CustomerDetailOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/17/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
protocol CustomerDetailOrderViewModelType: ObservableObject {
    var order: DbOrderModel { get }
    var portfolioImages: [String: UIImage?] { get set }
    var smallImagesPortfolio: [String] { get set }

    func getPortfolioImages(imagesPath: [String]) async throws
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws
    func deletePortfolioImage(pathKey: String) async throws

    func formattedDate(date: Date, format: String) -> String
    func sortedDate(array: [String]) -> [String]
    func currencySymbol(for regionCode: String) -> String


}
