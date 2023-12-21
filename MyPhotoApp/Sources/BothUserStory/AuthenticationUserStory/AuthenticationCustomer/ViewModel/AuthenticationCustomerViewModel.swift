////
////  AuthenticationCustomerViewModel.swift
////  MyPhotoApp
////
////  Created by Dima Stepanov on 11/19/23.
////
//
//import Foundation
//import SwiftUI
//
//@MainActor
//final class AuthenticationCustomerViewModel: AuthenticationCustomerViewModelType {
//    @Published var custmerEmail = ""
//    @Published var custmerPassword = ""
//    @Published var custmerErrorMessage = ""
//    
//    func setCustmerEmail(_ custmerEmail: String) {
//        self.custmerEmail = custmerEmail
//    }
//    func setCustmerPassword(_ custmerPassword: String) {
//        self.custmerPassword = custmerPassword
//    }
//    func authenticationCustomer() async throws {
//        guard !custmerEmail.isEmpty, !custmerPassword.isEmpty else {
//            print("No found Email or Password")
//            return
//        }
//        
//        do {
//            try await AuthNetworkService.shared.signInUser(email: custmerEmail, password: custmerPassword)
////            self.showAuthenticationCustomerView = false
////            self.userIsCustomer = try await getUserType()
//            
//        } catch {
//            do {
//                let authUserResult = try await AuthNetworkService.shared.createUser(email: custmerEmail, password: custmerPassword)
//                let dbUser = DBUserModel(auth: authUserResult, userType: "customer", firstName: "", secondName: "", instagramLink: "", phone: "", avatarUser: "", setPortfolio: false)
//                try await UserManager.shared.createNewCustomer(user: dbUser)
////                self.showAuthenticationCustomerView = false
//                
//            } catch {
////                self.showAuthenticationCustomerView = true
//
//            }
//        }
//    }
//    
//    func getUserType() async throws -> Bool {
//        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
//        let user = try await UserManager.shared.getUser(userId: userDataResult.uid)
//        
//        return user.userType == "customer"
//    }
//    
//}
