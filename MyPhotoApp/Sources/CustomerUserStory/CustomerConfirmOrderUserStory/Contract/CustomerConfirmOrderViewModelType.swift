//
//  CustomerConfirmOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/28/23.
//

import Foundation
import SwiftUI

@MainActor
protocol CustomerConfirmOrderViewModelType: ObservableObject {
    var authorName: String { get }
    var familynameAuthor: String { get }
    var location: String { get }
    var orderDate: Date { get }
    var orderTime: [String] { get }
    var orderDuration: String { get }
    var orderDescription: String { get set }
    var orderPrice: String { get }

    
    func formattedDate(date: Date, format: String) -> String
    func sortedDate(array: [String]) -> [String] 
}

