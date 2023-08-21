//
//  PortfolioModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/18/23.
//

import Foundation

struct PortfolioModel {
    var author: Author
    var avatarAuthor: String
    var smallImagesPortfolio: [String]
    var largeImagesPortfolio: [String]
    var descriptionAuthor: String
    var reviews: [Reviews]
    
}

struct Author {
    var id: String
    var rateAuthor: Double
    var likedAuthor: Bool
    var nameAuthor: String
    var countryCode: String
    var city: String
    var genreAuthor: [String]
    var imagesCover: [String]
    var priceAuthor: String

}

struct Appointmen {
    var avaibleAppointmen: [Date: [String]]
}

struct Reviews {
    var revieweverAuthor: Author
    var reviewDescription: String
    var reviewRate: Double
}
