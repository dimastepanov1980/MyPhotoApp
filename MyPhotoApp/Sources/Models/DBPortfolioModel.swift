//
//  DBPortfolioModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/18/23.
//

import Foundation

struct DBPortfolioModel: Codable {
    let id: String
    let author: DBAuthor?
    let avatarAuthor: String?
    let smallImagesPortfolio: [String]?
    let largeImagesPortfolio: [String]?
    let descriptionAuthor: String?
    let reviews: [DBReviews]?
    let appointmen: [DBAppointmen]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.author = try container.decodeIfPresent(DBAuthor.self, forKey: .author)
        self.avatarAuthor = try container.decodeIfPresent(String.self, forKey: .avatarAuthor)
        self.smallImagesPortfolio = try container.decodeIfPresent([String].self, forKey: .smallImagesPortfolio)
        self.largeImagesPortfolio = try container.decodeIfPresent([String].self, forKey: .largeImagesPortfolio)
        self.descriptionAuthor = try container.decodeIfPresent(String.self, forKey: .descriptionAuthor)
        self.reviews = try container.decodeIfPresent([DBReviews].self, forKey: .reviews)
        self.appointmen = try container.decodeIfPresent([DBAppointmen].self, forKey: .appointmen)
    }
    
    init(id: String, author: DBAuthor?, avatarAuthor: String?, smallImagesPortfolio: [String]?, largeImagesPortfolio: [String]?, descriptionAuthor: String?, reviews: [DBReviews]?, appointmen: [DBAppointmen]?) {
        self.id = id
        self.author = author
        self.avatarAuthor = avatarAuthor
        self.smallImagesPortfolio = smallImagesPortfolio
        self.largeImagesPortfolio = largeImagesPortfolio
        self.descriptionAuthor = descriptionAuthor
        self.reviews = reviews
        self.appointmen = appointmen
    }

    
    enum CodingKeys: String, CodingKey {
        case id = "author_id"
        case author = "author"
        case avatarAuthor = "avatar_author"
        case smallImagesPortfolio = "small_images_portfolio"
        case largeImagesPortfolio = "large_images_portfolio"
        case descriptionAuthor = "description_author"
        case reviews = "reviews"
        case appointmen = "avaible_appointment"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.author, forKey: .author)
        try container.encodeIfPresent(self.avatarAuthor, forKey: .avatarAuthor)
        try container.encodeIfPresent(self.smallImagesPortfolio, forKey: .smallImagesPortfolio)
        try container.encodeIfPresent(self.largeImagesPortfolio, forKey: .largeImagesPortfolio)
        try container.encodeIfPresent(self.descriptionAuthor, forKey: .descriptionAuthor)
        try container.encodeIfPresent(self.reviews, forKey: .reviews)
        try container.encodeIfPresent(self.appointmen, forKey: .appointmen)
    }
}

struct DBAuthor: Codable {
    let id: String
    let rateAuthor: Double
    let likedAuthor: Bool
    let nameAuthor: String
    let familynameAuthor: String
    let sexAuthor: String
    let ageAuthor: String
    let location: String
    let styleAuthor: [String]
    let imagesCover: [String]
    let priceAuthor: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.rateAuthor = try container.decode(Double.self, forKey: .rateAuthor)
        self.likedAuthor = try container.decode(Bool.self, forKey: .likedAuthor)
        self.nameAuthor = try container.decode(String.self, forKey: .nameAuthor)
        self.familynameAuthor = try container.decode(String.self, forKey: .familynameAuthor)
        self.sexAuthor = try container.decode(String.self, forKey: .sexAuthor)
        self.ageAuthor = try container.decode(String.self, forKey: .ageAuthor)
        self.location = try container.decode(String.self, forKey: .location)
        self.styleAuthor = try container.decode([String].self, forKey: .styleAuthor)
        self.imagesCover = try container.decode([String].self, forKey: .imagesCover)
        self.priceAuthor = try container.decode(String.self, forKey: .priceAuthor)
    }

    init(id: String, rateAuthor: Double, likedAuthor: Bool, nameAuthor: String, familynameAuthor: String, sexAuthor: String, ageAuthor: String, location: String, styleAuthor: [String], imagesCover: [String], priceAuthor: String) {
        self.id = id
        self.rateAuthor = rateAuthor
        self.likedAuthor = likedAuthor
        self.nameAuthor = nameAuthor
        self.familynameAuthor = familynameAuthor
        self.sexAuthor = sexAuthor
        self.ageAuthor = ageAuthor
        self.location = location
        self.styleAuthor = styleAuthor
        self.imagesCover = imagesCover
        self.priceAuthor = priceAuthor
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case rateAuthor = "rate_author"
        case likedAuthor = "liked_author"
        case nameAuthor = "name_author"
        case familynameAuthor = "familyname_author"
        case sexAuthor = "sex_author"
        case ageAuthor = "age_author"
        case location = "location"
        case styleAuthor = "style_author"
        case imagesCover = "images_cover"
        case priceAuthor = "price_author"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.rateAuthor, forKey: .rateAuthor)
        try container.encode(self.likedAuthor, forKey: .likedAuthor)
        try container.encode(self.nameAuthor, forKey: .nameAuthor)
        try container.encode(self.familynameAuthor, forKey: .familynameAuthor)
        try container.encode(self.sexAuthor, forKey: .sexAuthor)
        try container.encode(self.ageAuthor, forKey: .ageAuthor)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.styleAuthor, forKey: .styleAuthor)
        try container.encode(self.imagesCover, forKey: .imagesCover)
        try container.encode(self.priceAuthor, forKey: .priceAuthor)
    }
}

struct DBAppointmen: Codable {
    let id = UUID()
    let data: Date
    let timeSlot: [DBTimeSlot]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(Date.self, forKey: .data)
        self.timeSlot = try container.decode([DBTimeSlot].self, forKey: .timeSlot)
    }
    init(data: Date, timeSlot: [DBTimeSlot]) {
        self.data = data
        self.timeSlot = timeSlot
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "date"
        case timeSlot = "time_slot"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.timeSlot, forKey: .timeSlot)
    }
}

struct DBTimeSlot: Codable, Hashable {
    let time: String
    let available: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode(String.self, forKey: .time)
        self.available = try container.decode(Bool.self, forKey: .available)
    }
    init(time: String, available: Bool) {
        self.time = time
        self.available = available
    }
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case available = "available"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.available, forKey: .available)
    }
}

struct DBReviews: Codable {
    let reviewerAuthor: String?
    let reviewDescription: String?
    let reviewRate: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reviewerAuthor = try container.decode(String.self, forKey: .reviewerAuthor)
        self.reviewDescription = try container.decode(String.self, forKey: .reviewDescription)
        self.reviewRate = try container.decode(Double.self, forKey: .reviewRate)
    }
    init(reviewerAuthor: String? = nil, reviewDescription: String, reviewRate: Double) {
        self.reviewerAuthor = reviewerAuthor
        self.reviewDescription = reviewDescription
        self.reviewRate = reviewRate
    }

    enum CodingKeys: String, CodingKey {
        case reviewerAuthor = "reviewer_author"
        case reviewDescription = "review_description"
        case reviewRate = "review_rate"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.reviewerAuthor, forKey: .reviewerAuthor)
        try container.encode(self.reviewDescription, forKey: .reviewDescription)
        try container.encode(self.reviewRate, forKey: .reviewRate)
    }
}
