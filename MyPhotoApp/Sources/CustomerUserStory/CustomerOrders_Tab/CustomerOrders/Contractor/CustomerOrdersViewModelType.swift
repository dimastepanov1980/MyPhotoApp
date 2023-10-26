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

    func subscribe() async throws
}
