//
//  PortfolioViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/31/23.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI

@MainActor
protocol PortfolioViewModelType: ObservableObject {
    var avatarAuthor: String { get set }
    var avatarURL: URL? { get set }
    var nameAuthor: String { get set }
    var typeAuthor: String { get set }
    var familynameAuthor: String { get set }
    var ageAuthor: String { get set }
    var sexAuthor: String { get set }
    var styleAuthor: [String] { get set }
    var descriptionAuthor: String { get set }
    var dbModel: DBPortfolioModel? { get set }
    var avatarAuthorID: UUID { get set }
// MARK: - SearchLocation property
    var locationAuthor: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var regionAuthor: String { get set }
    var identifier: String { get set }
    var smallImagesPortfolio: [String] { get }
    var portfolioImages: [String : UIImage?] { get set }
    
    func updatePreview()
    func getAuthorPortfolio() async throws
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws
    func deletePortfolioImage(pathKey: String) async throws
    func getPortfolioImages(imagesPath: [String]) async throws
}
