//
//  ScheduleModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/9/23.
//

import Foundation

struct Schedule: Codable {
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
    
    init(dbSchdul: DbSchedule) {
        self.id = dbSchdul.id
        self.holidays = dbSchdul.holidays
        self.startDate = dbSchdul.startDate
        self.endDate = dbSchdul.endDate
        self.timeIntervalSelected = dbSchdul.timeIntervalSelected
        self.price = dbSchdul.price
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
