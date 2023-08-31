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
    init(items: AuthorPortfolioModel) {
        self.items = items
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
