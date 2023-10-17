//
//  CustomerDetailOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/17/23.
//

import Foundation
import SwiftUI

@MainActor

final class CustomerDetailOrderViewModel: CustomerDetailOrderViewModelType {
    
    @Published var order: DbOrderModel
    
    init(order: DbOrderModel){
        self.order = order
    }
    
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
    
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
}
