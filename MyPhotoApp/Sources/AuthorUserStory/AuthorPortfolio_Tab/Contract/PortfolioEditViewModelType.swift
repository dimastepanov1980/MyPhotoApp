//
//  PortfolioEditViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/13/23.
//

import Foundation
import SwiftUI
import PhotosUI


@MainActor
protocol PortfolioEditViewModelType: ObservableObject {
    var sexAuthorList: [String] { get }
    var locationAuthor: String { get set }
    var regionAuthor: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var nameAuthor: String { get set }
    var familynameAuthor: String { get set }
    var sexAuthor: String { get set }
    var ageAuthor: String { get set }
    var styleAuthor: [String] { get set }
    var typeAuthor: String { get set }
    var avatarAuthor: String { get set }
    var avatarImage: UIImage? { get set }
    var descriptionAuthor: String { get set }
    var locationResult: [DBLocationModel] { get set }

    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws
    func addAvatar(selectImage: PhotosPickerItem?) async throws
    func searchLocation(text: String)
    func getAvatarImage(imagePath: String) async throws

}
