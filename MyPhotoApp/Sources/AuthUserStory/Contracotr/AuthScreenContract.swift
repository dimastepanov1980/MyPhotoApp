//
//  Contract.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import SwiftUI

@MainActor
protocol AuthScreenViewModelType: ObservableObject {
//    var userID: UUID { get }
    var signInEmail: String { get }
    var signInPassword: String { get }
    var errorMasswge: String { get set }

    func setSignInEmail(_ signInEmail: String)
    func setSignInPassword(_ signInPassword: String)
    func registrationUser() async throws

    var signUpEmail: String { get }
    var signUpPassword: String { get }

    func setSignUpEmail(_ signUpEmail: String)
    func setSignUpPassword(_ signUpPassword: String)
    func loginUser() async throws
    
    func resetPassword() async throws
}
