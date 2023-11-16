//
//  AuthenticationScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import SwiftUI

@MainActor
protocol AuthenticationScreenViewModelType: ObservableObject {
    var showAuthenticationView: Bool { get set }
    var userIsCustomer: Bool { get set }
    func getUserType() async throws -> Bool
    
    var custmerEmail: String { get }
    var custmerPassword: String { get }
    var custmerErrorMessage: String { get set }

    func setCustmerEmail(_ custmerEmail: String)
    func setCustmerPassword(_ custmerPassword: String)
    func authenticationCustomer() async throws
    
    var authorEmail: String { get }
    var authorPassword: String { get }
    var authorErrorMessage: String { get set }
    func authenticationAuthor() async throws


    func setAuthorEmail(_ authorEmail: String)
    func setAuthorPassword(_ authorPassword: String)
    
    func resetPassword() async throws
}
