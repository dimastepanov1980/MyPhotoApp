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

    var portfolio: AuthorPortfolioModel? { get set }
    var portfolioImages: [String : UIImage?] { get set }
    var avatarImage: UIImage? { get set }
    
    func getAuthorPortfolio() async throws
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws
    func deletePortfolioImage(pathKey: String) async throws
    func getPortfolioImages(imagesPath: [String]) async throws
    func getAvatarImage(imagePath: String) async throws
}
