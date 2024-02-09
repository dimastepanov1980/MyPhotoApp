//
//  SignInViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/19/23.
//
import Foundation
import SwiftUI

@MainActor
protocol SignInSignUpViewModelType: ObservableObject {

    var email: String { get set }
    var password: String { get set }
    var errorMessage: String { get set }
    var userType: String { get set }
    
    func signIn() async throws
    func signUp() async throws
    func resetPassword() async throws
}
