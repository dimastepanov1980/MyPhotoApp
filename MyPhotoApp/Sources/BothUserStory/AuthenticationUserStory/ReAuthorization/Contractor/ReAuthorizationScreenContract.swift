//
//  ReAuthenticationScreenContract.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/13/23.
//

import Foundation

@MainActor
protocol ReAuthenticationViewModelType: ObservableObject {
    var reSignInPassword: String { get set }
    var errorMessage: String { get set }

    func deleteUser(password: String) async throws
}
