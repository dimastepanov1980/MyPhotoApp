//
//  CustomerDetailScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/26/23.
//

import Foundation
import SwiftUI

@MainActor
final class CustomerDetailScreenViewModel: CustomerDetailScreenViewModelType {
    @Published var items: AuthorPortfolioModel
    @Published var selectedDay: Date? = nil
    @Published var selectedTime: [String] = []
    @Published var today: Date = Date()
    @Published var timeslotSelectedDay: [DBTimeSlot] = []
    @Published var appointments: [AppointmenModel] = []
    
    var startMyTrip: Date

    init(items: AuthorPortfolioModel,
         startMyTrip: Date) {
        self.items = items
        self.startMyTrip = startMyTrip
        createAppointments(schedule: items.appointmen, startMyTripDate: self.startMyTrip)

    }
    
    private func setEndMyTripDate(startMyTrip: Date, endMyTrip: Int) -> Date{
        let today = startMyTrip
        let calendar = Calendar.current
        guard let endMyTripDate = calendar.date(byAdding: .day, value: endMyTrip, to: today) else { return Date()}
        return endMyTripDate
    }
    
    func createAppointments(schedule: [DbSchedule], startMyTripDate: Date) {
        let endMyTripDate = setEndMyTripDate(startMyTrip: startMyTripDate, endMyTrip: 10)
        var appointments: [AppointmenModel] = []
        let calendar = Calendar.current
        
        var currentDate = startMyTripDate

        while currentDate <= endMyTripDate {
            let timeSlots: [TimeSlotModel] = []
            let appointmentModel = AppointmenModel(date: currentDate, timeSlot: timeSlots)
            appointments.append(appointmentModel)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        self.appointments = appointments
    }
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
    func stringToURL(imageString: String) -> URL? {
        guard let imageURL = URL(string: imageString) else { return nil }
        return imageURL
    }
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
    func isTodayDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(today, inSameDayAs: date)
    }
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDay ?? Date(), inSameDayAs: date)
    }

}
