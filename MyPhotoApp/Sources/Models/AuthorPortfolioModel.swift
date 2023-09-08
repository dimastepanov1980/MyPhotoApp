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
    let id: String
    let rateAuthor: Double
    let likedAuthor: Bool
    let nameAuthor: String
    let familynameAuthor: String
    let sexAuthor: String
    let location: String
    let styleAuthor: [String]
    let imagesCover: [String]
    let priceAuthor: String
    
    init(author: DBAuthor) {
        self.id = author.id
        self.rateAuthor = author.rateAuthor
        self.likedAuthor = author.likedAuthor
        self.nameAuthor = author.nameAuthor
        self.familynameAuthor = author.familynameAuthor
        self.sexAuthor = author.sexAuthor
        self.location = author.location
        self.styleAuthor = author.styleAuthor
        self.imagesCover = author.imagesCover
        self.priceAuthor = author.priceAuthor
    }
}

struct AppointmenModel {
    let data: Date
    let timeSlot: [DBTimeSlot]
}

struct TimeSlotModel {
    let time: String
    let available: Bool
    
    init(dbTimeSlot: DBTimeSlot) {
        self.time = dbTimeSlot.time
        self.available = dbTimeSlot.available
    }
}

struct ReviewsModel {
    let reviewerAuthor: String
    let reviewDescription: String
    let reviewRate: Double
    
    init(review: DBReviews) {
        self.reviewerAuthor = review.reviewerAuthor ?? ""
        self.reviewDescription = review.reviewDescription ?? ""
        self.reviewRate = review.reviewRate ?? 0
    }
}
