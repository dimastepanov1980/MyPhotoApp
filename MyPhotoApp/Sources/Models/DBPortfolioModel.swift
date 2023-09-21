//
//  DBPortfolioModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/18/23.
//

import Foundation

struct DBPortfolioModel: Codable, Hashable {
    let id: String
    let author: DBAuthor?
    let avatarAuthor: String?
    let smallImagesPortfolio: [String]?
    let largeImagesPortfolio: [String]?
    let descriptionAuthor: String?
//    let reviews: [DBReviews]?
    let schedule: [DbSchedule]?
//    let bookingDays: [BookinDate]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.author = try container.decodeIfPresent(DBAuthor.self, forKey: .author)
        self.avatarAuthor = try container.decodeIfPresent(String.self, forKey: .avatarAuthor)
        self.smallImagesPortfolio = try container.decodeIfPresent([String].self, forKey: .smallImagesPortfolio)
        self.largeImagesPortfolio = try container.decodeIfPresent([String].self, forKey: .largeImagesPortfolio)
        self.descriptionAuthor = try container.decodeIfPresent(String.self, forKey: .descriptionAuthor)
//        self.reviews = try container.decodeIfPresent([DBReviews].self, forKey: .reviews)
        self.schedule = try container.decodeIfPresent([DbSchedule].self, forKey: .schedule)
//        self.bookingDays = try container.decodeIfPresent([BookinDate].self, forKey: .bookingDays)
    }
    
    init(id: String, author: DBAuthor?,
         avatarAuthor: String?,
         smallImagesPortfolio: [String]?,
         largeImagesPortfolio: [String]?,
         descriptionAuthor: String?,
//         reviews: [DBReviews]?,
         schedule: [DbSchedule]?
//         bookingDays: [BookinDate]?
    ){   self.id = id
        self.author = author
        self.avatarAuthor = avatarAuthor
        self.smallImagesPortfolio = smallImagesPortfolio
        self.largeImagesPortfolio = largeImagesPortfolio
        self.descriptionAuthor = descriptionAuthor
//        self.reviews = reviews
        self.schedule = schedule
//        self.bookingDays = bookingDays
    }

    func hash(into hasher: inout Hasher) {
           // Use properties that uniquely identify a portfolio to generate the hash value
           hasher.combine(self.id) // Replace with an actual unique identifier property
       }

       static func == (lhs: DBPortfolioModel, rhs: DBPortfolioModel) -> Bool {
           // Implement equality based on properties that make a portfolio equal
           return lhs.id == rhs.id // Replace with actual comparison logic
       }
    
    enum CodingKeys: String, CodingKey {
        case id = "author_id"
        case author = "author"
        case avatarAuthor = "avatar_author"
        case smallImagesPortfolio = "small_images_portfolio"
        case largeImagesPortfolio = "large_images_portfolio"
        case descriptionAuthor = "description_author"
//        case reviews = "reviews"
        case schedule = "avaible_schedule"
        case bookingDays = "booking_days"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.author, forKey: .author)
        try container.encodeIfPresent(self.avatarAuthor, forKey: .avatarAuthor)
        try container.encodeIfPresent(self.smallImagesPortfolio, forKey: .smallImagesPortfolio)
        try container.encodeIfPresent(self.largeImagesPortfolio, forKey: .largeImagesPortfolio)
        try container.encodeIfPresent(self.descriptionAuthor, forKey: .descriptionAuthor)
//        try container.encodeIfPresent(self.reviews, forKey: .reviews)
        try container.encodeIfPresent(self.schedule, forKey: .schedule)
//        try container.encodeIfPresent(self.bookingDays, forKey: .bookingDays)
    }
}

struct BookinDate: Codable {
    let dateStart: Date
    let dateEnd: Date
    let dayOff: Bool
    let orderId: String
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateStart = try container.decode(Date.self, forKey: .dateStart)
        self.dateEnd = try container.decode(Date.self, forKey: .dateEnd)
        self.dayOff = try container.decode(Bool.self, forKey: .dayOff)
        self.orderId = try container.decode(String.self, forKey: .orderId)
    }
    enum CodingKeys: String, CodingKey {
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case dayOff = "day_off"
        case orderId = "order_id"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dateStart, forKey: .dateStart)
        try container.encode(self.dateEnd, forKey: .dateEnd)
        try container.encode(self.dayOff, forKey: .dayOff)
        try container.encode(self.orderId, forKey: .orderId)
    }
}

struct DBAuthor: Codable {
    let rateAuthor: Double
    let likedAuthor: Bool
    let typeAuthor: String
    let nameAuthor: String
    let familynameAuthor: String
    let sexAuthor: String
    let ageAuthor: String
    let location: String
    let regionAuthor: String
    var latitude: Double
    var longitude: Double
    let styleAuthor: [String]
    let imagesCover: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rateAuthor = try container.decode(Double.self, forKey: .rateAuthor)
        self.typeAuthor = try container.decode(String.self, forKey: .typeAuthor)
        self.likedAuthor = try container.decode(Bool.self, forKey: .likedAuthor)
        self.nameAuthor = try container.decode(String.self, forKey: .nameAuthor)
        self.familynameAuthor = try container.decode(String.self, forKey: .familynameAuthor)
        self.sexAuthor = try container.decode(String.self, forKey: .sexAuthor)
        self.ageAuthor = try container.decode(String.self, forKey: .ageAuthor)
        self.location = try container.decode(String.self, forKey: .location)
        self.regionAuthor = try container.decode(String.self, forKey: .regionAuthor)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.styleAuthor = try container.decode([String].self, forKey: .styleAuthor)
        self.imagesCover = try container.decode([String].self, forKey: .imagesCover)
    }

    init(rateAuthor: Double, likedAuthor: Bool, typeAuthor: String, nameAuthor: String, familynameAuthor: String, sexAuthor: String, ageAuthor: String, location: String, latitude: Double, longitude: Double, regionAuthor: String, styleAuthor: [String], imagesCover: [String]) {
        self.rateAuthor = rateAuthor
        self.likedAuthor = likedAuthor
        self.typeAuthor = typeAuthor
        self.nameAuthor = nameAuthor
        self.familynameAuthor = familynameAuthor
        self.sexAuthor = sexAuthor
        self.ageAuthor = ageAuthor
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.regionAuthor = regionAuthor
        self.styleAuthor = styleAuthor
        self.imagesCover = imagesCover
    }
    
    enum CodingKeys: String, CodingKey {
        case rateAuthor = "rate_author"
        case likedAuthor = "liked_author"
        case typeAuthor = "type_author"
        case nameAuthor = "name_author"
        case familynameAuthor = "familyname_author"
        case sexAuthor = "sex_author"
        case ageAuthor = "age_author"
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
        case regionAuthor = "region_author"
        case styleAuthor = "style_author"
        case imagesCover = "images_cover"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rateAuthor, forKey: .rateAuthor)
        try container.encode(self.typeAuthor, forKey: .typeAuthor)
        try container.encode(self.likedAuthor, forKey: .likedAuthor)
        try container.encode(self.nameAuthor, forKey: .nameAuthor)
        try container.encode(self.familynameAuthor, forKey: .familynameAuthor)
        try container.encode(self.sexAuthor, forKey: .sexAuthor)
        try container.encode(self.ageAuthor, forKey: .ageAuthor)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.regionAuthor, forKey: .regionAuthor)
        try container.encode(self.styleAuthor, forKey: .styleAuthor)
        try container.encode(self.imagesCover, forKey: .imagesCover)
    }
}

struct DbSchedule: Codable {
    let id: UUID
    var holidays: Bool
    var startDate: Date
    var endDate: Date
    var timeIntervalSelected: String
    var price: String
    
    init(id: UUID, holidays: Bool, startDate: Date, endDate: Date, timeIntervalSelected: String, price: String) {
        self.id = id
        self.holidays = holidays
        self.startDate = startDate
        self.endDate = endDate
        self.timeIntervalSelected = timeIntervalSelected
        self.price = price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.holidays = try container.decode(Bool.self, forKey: .holidays)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
        self.timeIntervalSelected = try container.decode(String.self, forKey: .timeIntervalSelected)
        self.price = try container.decode(String.self, forKey: .price)
    }
    enum CodingKeys: String, CodingKey {
        case id = "id_schedule"
        case holidays = "holidays"
        case startDate = "start_date"
        case endDate = "end_date"
        case timeIntervalSelected = "time_interval"
        case price = "price"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.holidays, forKey: .holidays)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.timeIntervalSelected, forKey: .timeIntervalSelected)
        try container.encode(self.price, forKey: .price)
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
