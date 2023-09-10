//
//  PortfolioScheduleViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/9/23.
//

import Foundation

@MainActor
protocol PortfolioScheduleViewModelType: ObservableObject {
    var startDate: Date { get set }
    var endDate: Date { get set }
    var timeIntervalSelected: String { get set }
    var holidays: Bool { get set }
    var price: String { get set }
    var schedules: [Schedule] { get set }
    
    func setSchedule(schedules: [Schedule]) async throws
}
