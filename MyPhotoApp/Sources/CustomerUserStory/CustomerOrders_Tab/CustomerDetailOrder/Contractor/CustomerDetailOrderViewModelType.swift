//
//  CustomerDetailOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/17/23.
//

import Foundation
import SwiftUI

@MainActor
protocol CustomerDetailOrderViewModelType: ObservableObject {
    var order: DbOrderModel { get }
    
    func formattedDate(date: Date, format: String) -> String
    func sortedDate(array: [String]) -> [String]
    func currencySymbol(for regionCode: String) -> String


}
