//
//  ReAuthenticationViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/13/23.
//

import Foundation

@MainActor
final class ReAuthenticationViewModel: ReAuthenticationViewModelType{
    @Published var reSignInPassword: String = ""
    @Published var errorMessage: String = ""
    
    func deleteUser(password: String) async throws {
        try await AuthNetworkService.shared.deleteUser(password: password)
    }
}
