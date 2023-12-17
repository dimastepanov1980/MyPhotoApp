//
//  AuthenticationCustomerViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/19/23.
//

import Foundation
import SwiftUI

@MainActor
protocol AuthenticationCustomerViewModelType: ObservableObject {
//    var showAuthenticationCustomerView: Bool { get set }
//    var userIsCustomer: Bool { get set }
    func getUserType() async throws -> Bool
    
    var custmerEmail: String { get }
    var custmerPassword: String { get }
    var custmerErrorMessage: String { get set }

    func setCustmerEmail(_ custmerEmail: String)
    func setCustmerPassword(_ custmerPassword: String)
    func authenticationCustomer() async throws

}
