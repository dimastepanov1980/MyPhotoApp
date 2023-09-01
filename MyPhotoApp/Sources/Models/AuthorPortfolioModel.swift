//
//  AuthorPortfolioModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/22/23.
//

import Foundation

struct AuthorPortfolioModel {
    let id: String
    let author: DBAuthor?
    let avatarAuthor: String
    let smallImagesPortfolio: [String]
    let largeImagesPortfolio: [String]
    let descriptionAuthor: String
    let reviews: [DBReviews]
    let appointmen: [DBAppointmen]
    
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
    var familynameAuthor: String
    var sexAuthor: String
    var countryCode: String
    var city: String
    var genreAuthor: [String]
    var imagesCover: [String]
    var priceAuthor: String
    
    init(author: DBAuthor) {
        self.id = author.id
        self.rateAuthor = author.rateAuthor
        self.likedAuthor = author.likedAuthor
        self.nameAuthor = author.nameAuthor
        self.familynameAuthor = author.familynameAuthor
        self.sexAuthor = author.sexAuthor
        self.countryCode = author.countryCode
        self.city = author.city
        self.genreAuthor = author.genreAuthor
        self.imagesCover = author.imagesCover
        self.priceAuthor = author.priceAuthor
    }
}

struct AppointmenModel {
    var data: Date
    var timeSlot: [DBTimeSlot]
}

struct TimeSlotModel {
    var time: String
    var available: Bool
    
    init(dbTimeSlot: DBTimeSlot) {
        self.time = dbTimeSlot.time
        self.available = dbTimeSlot.available
    }
}

struct ReviewsModel {
    var reviewerAuthor: String
    var reviewDescription: String
    var reviewRate: Double
    
    init(review: DBReviews) {
        self.reviewerAuthor = review.reviewerAuthor ?? ""
        self.reviewDescription = review.reviewDescription ?? ""
        self.reviewRate = review.reviewRate ?? 0
    }
}
