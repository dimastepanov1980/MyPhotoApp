//
//  PortfolioViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/31/23.
//

import Foundation
import Combine

@MainActor
protocol PortfolioViewModelType: ObservableObject {
    var avatarAuthor: String { get set }
    var nameAuthor: String { get set }
    var familynameAuthor: String { get set }
    var ageAuthor: String { get set }
    var sexAuthor: String { get set }
//    var location: String { get set }
    var styleAuthor: [String] { get set }
    var descriptionAuthor: String { get set }
    var styleOfPhotography: [String] { get set }
    var sexAuthorList: [String] { get set }
    var dbModel: DBPortfolioModel? { get set }
    
// MARK: - SearchLocation property
    var locationAuthor: String { get set }
    var locationResult: [DBLocationModel] { get set }
    
    func updatePreview()
    func getAuthorPortfolio() async throws
    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws
    
}
