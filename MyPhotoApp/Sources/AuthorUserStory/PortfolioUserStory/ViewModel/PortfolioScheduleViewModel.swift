//
//  PortfolioScheduleViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/9/23.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class PortfolioScheduleViewModel: PortfolioScheduleViewModelType {
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var timeIntervalSelected: String = ""
    @Published var holidays: Bool = false
    @Published var price: String = ""
    @Published var schedules: [Schedule]
  
    init () {
        self.schedules = []
        Task {
            do {
                let dBschedules = try await getSchedule()
                self.schedules = dBschedules.map { Schedule(dbSchdul: $0) }
            } catch {
                print(error.localizedDescription)

            }
        }
    }
    

    func setSchedule(schedules: [Schedule]) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        if schedules.isEmpty  {
            print("array is isEmpty")
            try await UserManager.shared.removeUserSchedule(userId: authDateResult.uid)
        } else {
            print("Total array \(schedules.count):\(schedules)")
            try await UserManager.shared.removeUserSchedule(userId: authDateResult.uid)
            for schedule in schedules {
                print("each:\(schedule)")
                print("timeZone: \(schedule.timeZone)")
                
                try? await UserManager.shared.setUserSchedule(userId: authDateResult.uid, schedules: schedule)
            }
        }
    }
    
    func getSchedule() async throws -> [DbSchedule] {
        do {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            let dBschedule = try await UserManager.shared.getUserSchedule(userId: authDateResult.uid)
            guard let schedule =  dBschedule.schedule else { return [] }
            return schedule
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
