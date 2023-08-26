//
//  AuthorPortfolioModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/22/23.
//

import Foundation

struct AuthorPortfolioModel {
    let id: String
    let author: Author?
    let avatarAuthor: String
    let smallImagesPortfolio: [String]
    let largeImagesPortfolio: [String]
    let descriptionAuthor: String
    let reviews: [Reviews]
    let appointmen: [Appointmen]
    
    init(portfolio: DBPortfolioModel) {
        self.id = portfolio.id
        self.author = portfolio.author
        self.avatarAuthor = portfolio.avatarAuthor ?? ""
        self.smallImagesPortfolio = portfolio.smallImagesPortfolio ?? []
        self.largeImagesPortfolio = portfolio.largeImagesPortfolio ?? []
        self.descriptionAuthor = portfolio.descriptionAuthor ?? ""
        self.reviews = portfolio.reviews ?? []
        self.appointmen = portfolio.appointmen ?? []
    }
}

struct AuthorModel {
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

struct AppointmenModel {
    var data: Date
    var timeSlot: [TimeSlot]
}

struct TimeSlotModel {
    var time: String
    var available: Bool
}

struct ReviewsModel {
    var reviewerAuthor: String
    var reviewDescription: String
    var reviewRate: Double
}
