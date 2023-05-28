//
//  Contract.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import SwiftUI

protocol AuthScreenViewModelType: ObservableObject {
//    var userID: UUID { get }
    var signInEmail: String { get }
    var signInPassword: String { get }

    func setSignInEmail(_ signInEmail: String)
    func setSignInPassword(_ signInPassword: String)
    func signIn()

    var signUpEmail: String { get }
    var signUpPassword: String { get }

    func setSignUpEmail(_ signUpEmail: String)
    func setSignUpPassword(_ signUpPassword: String)
    func signUp()
}
