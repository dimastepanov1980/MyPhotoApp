//
//  CustomerOrdersContractor.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import Foundation
import SwiftUI

@MainActor
protocol CustomerOrdersViewModelType: ObservableObject {
    var orders: [OrderModel] { get }
    var newMessagesCount: Int { get set }
    func orderStausColor (order: String?) -> Color
    func orderStausName (status: String?) -> String
    func subscribe() async throws
}
