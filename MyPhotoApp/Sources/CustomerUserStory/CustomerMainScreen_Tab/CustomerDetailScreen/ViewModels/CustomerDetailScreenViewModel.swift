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
    @Published var customer: DBUserModel?
    @Published var selectedDay: Date? = nil
    @Published var selectedTime: [String] = []
    @Published var priceForDay: String = ""
    @Published var minPrice: String = ""
    @Published var today: Date = Date()
    @Published var timeslotSelectedDay: [TimeSlotModel] = []
    @Published var appointments: [AppointmentModel] = []
    
    var startMyTrip: Date
    
    init(items: AuthorPortfolioModel,
         startMyTrip: Date) {
        self.items = items
        self.startMyTrip = startMyTrip
        
        createAppointments(schedule: items.appointmen, startMyTripDate: self.startMyTrip)
        getMinPrice()
    }
    
    private func getMinPrice(){
        var arrayPrices: [Int] = []
      
        for item in items.appointmen {
            if let price = Int(item.price) {
                arrayPrices.append(price)
            }
        }
        guard let minPrice = arrayPrices.min() else { return }
        self.minPrice = String(minPrice)
      }
    
    private func setEndMyTripDate(startMyTrip: Date, endMyTrip: Int) -> Date{
        let today = startMyTrip
        let calendar = Calendar.current
        guard let endMyTripDate = calendar.date(byAdding: .day, value: endMyTrip, to: today) else { return Date()}
        return endMyTripDate
    }
    func createAppointments(schedule: [DbSchedule], startMyTripDate: Date) {
        var appointments: [AppointmentModel] = []
        let calendar = Calendar.current
        var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter
        }
        var timeFormatter: DateFormatter {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter
        }
        var currentDate = startMyTripDate
        let endMyTripDate = setEndMyTripDate(startMyTrip: startMyTripDate, endMyTrip: 13)
        
        while currentDate <= endMyTripDate {
            var timeSlots: [TimeSlotModel] = []
            var priceForCurrentDay = ""
            
            for scheduleItem in schedule {
                if currentDate >= scheduleItem.startDate && currentDate <= scheduleItem.endDate {
                    let startTimeComponents = calendar.dateComponents([.hour, .minute], from: scheduleItem.startDate)
                    let endTimeComponents = calendar.dateComponents([.hour, .minute], from: scheduleItem.endDate)
                    guard let startHour = startTimeComponents.hour, let startMinute = startTimeComponents.minute,
                          let endHour = endTimeComponents.hour, let endMinute = endTimeComponents.minute else {
                        continue
                    }
                    
                    var currentTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: currentDate)!
                    
                    while currentTime <= calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: currentDate)! {
                        let timeSlot = TimeSlotModel(time: timeFormatter.string(from: currentTime), available: true)
                        timeSlots.append(timeSlot)
                        currentTime = calendar.date(byAdding: .minute, value: Int(scheduleItem.timeIntervalSelected) ?? 60, to: currentTime)!
                    }
                    priceForCurrentDay = scheduleItem.price
                }
            }
            
            if !timeSlots.isEmpty {
                let appointmentModel = AppointmentModel(date: currentDate, timeSlot: timeSlots, price: priceForCurrentDay)
                appointments.append(appointmentModel)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // Print appointments
        for appointment in appointments {
            print("Date: \(dateFormatter.string(from: appointment.date)), Time Slots: \(appointment.timeSlot)")
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
