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
    var selectedAvatar: PhotosPickerItem? { get set }
    var nameAuthor: String { get set }
    var familynameAuthor: String { get set }
    var ageAuthor: String { get set }
    var sexAuthor: String { get set }
    var styleAuthor: [String] { get set }
    var descriptionAuthor: String { get set }
    var styleOfPhotography: [String] { get set }
    var sexAuthorList: [String] { get set }
    var dbModel: DBPortfolioModel? { get set }
    var avatarImageID: UUID { get set }
    
// MARK: - SearchLocation property
    var locationAuthor: String { get set }
    var locationResult: [DBLocationModel] { get set }
    
    func updatePreview()
    func getAuthorPortfolio() async throws
    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws
    func addAvatar(selectImage: PhotosPickerItem?) async throws
    func avatarPathToURL(path: String) async throws -> URL
}
