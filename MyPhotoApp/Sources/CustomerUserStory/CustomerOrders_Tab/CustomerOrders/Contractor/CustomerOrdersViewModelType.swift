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
    var orders: [DbOrderModel] { get }
//    var getMessages: [String : [MessageModel]]?  { get set }

    func orderStausColor (order: String?) -> Color
    func orderStausName (status: String?) -> String
    func subscribe() async throws
//    func subscribeMessageCustomer() async throws
}
