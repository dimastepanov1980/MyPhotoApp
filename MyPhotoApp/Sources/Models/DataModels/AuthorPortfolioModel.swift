//
//  AuthorPortfolioModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/22/23.
//

import Foundation

struct AuthorPortfolioModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
         
     }

     static func == (lhs: AuthorPortfolioModel, rhs: AuthorPortfolioModel) -> Bool {
         return lhs.id == rhs.id
     }
    
    let id: String
    let author: DBAuthor?
    let avatarAuthor: String
    let smallImagesPortfolio: [String]
    let largeImagesPortfolio: [String]
    let descriptionAuthor: String
//    let reviews: [DBReviews]
    let schedule: [DbSchedule]
    let bookingDays: [String : [String]]?

    
    init(portfolio: DBPortfolioModel) {
        self.id = portfolio.id
        self.author = portfolio.author
        self.avatarAuthor = portfolio.avatarAuthor ?? ""
        self.smallImagesPortfolio = portfolio.smallImagesPortfolio ?? []
        self.largeImagesPortfolio = portfolio.largeImagesPortfolio ?? []
        self.descriptionAuthor = portfolio.descriptionAuthor ?? ""
//        self.reviews = portfolio.reviews ?? []
        self.schedule = portfolio.schedule ?? []
        self.bookingDays = portfolio.bookingDays ?? [:]
    }
}

struct AuthorModel {
    let rateAuthor: Double
    let likedAuthor: Bool
    let typeAuthor: String
    let nameAuthor: String
    let familynameAuthor: String
    let sexAuthor: String
    let location: String
    let regionAuthor: String
    let styleAuthor: [String]
    let imagesCover: [String]
    
    init(author: DBAuthor) {
        self.rateAuthor = author.rateAuthor
        self.likedAuthor = author.likedAuthor
        self.typeAuthor = author.typeAuthor
        self.nameAuthor = author.nameAuthor
        self.familynameAuthor = author.familynameAuthor
        self.sexAuthor = author.sexAuthor
        self.location = author.location
        self.regionAuthor = author.regionAuthor
        self.styleAuthor = author.styleAuthor
        self.imagesCover = author.imagesCover
    }
}

struct AppointmentModel {
    let date: Date
    let timeSlot: [String]
    let price: String
}

struct TimeSlotModel: Hashable {
    let time: String
    let available: Bool
    
    init(time: String, available: Bool) {
        self.time = time
        self.available = available
    }

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
