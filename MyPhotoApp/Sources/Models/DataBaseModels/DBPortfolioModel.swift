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
    let bookingDays: [String : [String]]?
    
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
        self.bookingDays = try container.decodeIfPresent([String : [String]].self, forKey: .bookingDays)
    }
    
    init(id: String, author: DBAuthor?,
         avatarAuthor: String?,
         smallImagesPortfolio: [String]?,
         largeImagesPortfolio: [String]?,
         descriptionAuthor: String?,
//         reviews: [DBReviews]?,
         schedule: [DbSchedule]?,
         bookingDays: [String : [String]]?) {
        
        self.id = id
        self.author = author
        self.avatarAuthor = avatarAuthor
        self.smallImagesPortfolio = smallImagesPortfolio
        self.largeImagesPortfolio = largeImagesPortfolio
        self.descriptionAuthor = descriptionAuthor
//        self.reviews = reviews
        self.schedule = schedule
        self.bookingDays = bookingDays
    }

    func hash(into hasher: inout Hasher) {
           hasher.combine(self.id)
       }

       static func == (lhs: DBPortfolioModel, rhs: DBPortfolioModel) -> Bool {
           return lhs.id == rhs.id
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
        try container.encodeIfPresent(self.bookingDays, forKey: .bookingDays)
    }
}

struct BookingDayOld: Codable {
    let date: Date
    var time: [String]
    let dayOff: Bool
    
    init(date: Date, time: [String], dayOff: Bool) {
        self.date = date
        self.time = time
        self.dayOff = dayOff
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.time = try container.decode([String].self, forKey: .time)
        self.dayOff = try container.decode(Bool.self, forKey: .dayOff)
    }
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case time = "time"
        case dayOff = "day_off"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.dayOff, forKey: .dayOff)
    }
}
struct BookingDay: Codable {
    var dayAndTime: [String : [String]]
    
    init(dayAndTime: [String : [String]]) {
        self.dayAndTime = dayAndTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dayAndTime = try container.decode([String : [String]].self, forKey: .dayAndTime)
    }
}

struct DbSchedule: Codable {
    let id: UUID
    var holidays: Bool
    var startDate: Date
    var endDate: Date
    var timeIntervalSelected: String
    var price: String
    var timeZone: String
    
    init(id: UUID, holidays: Bool, startDate: Date, endDate: Date, timeIntervalSelected: String, price: String, timeZone: String) {
        self.id = id
        self.holidays = holidays
        self.startDate = startDate
        self.endDate = endDate
        self.timeIntervalSelected = timeIntervalSelected
        self.price = price
        self.timeZone = timeZone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.holidays = try container.decode(Bool.self, forKey: .holidays)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
        self.timeIntervalSelected = try container.decode(String.self, forKey: .timeIntervalSelected)
        self.price = try container.decode(String.self, forKey: .price)
        self.timeZone = try container.decode(String.self, forKey: .timeZone)
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_schedule"
        case holidays = "holidays"
        case startDate = "start_date"
        case endDate = "end_date"
        case timeIntervalSelected = "time_interval"
        case price = "price"
        case timeZone = "time_zone"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.holidays, forKey: .holidays)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.timeIntervalSelected, forKey: .timeIntervalSelected)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.timeZone, forKey: .timeZone)
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
