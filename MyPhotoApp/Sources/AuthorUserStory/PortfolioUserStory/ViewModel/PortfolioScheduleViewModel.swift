//
//  PortfolioScheduleViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/9/23.
//

import Foundation
import SwiftUI

@MainActor
final class PortfolioScheduleViewModel: PortfolioScheduleViewModelType {
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var timeIntervalSelected: String = ""
    @Published var holidays: Bool = false
    @Published var price: String = ""
    @Published var schedules: [Schedule] = []
    

    func setSchedule(schedules: [Schedule]) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        for schedule in schedules {
            try? await UserManager.shared.setSchedule(userId: authDateResult.uid, schedules: schedule)
                    print(schedule)
        }
    }
    
}
