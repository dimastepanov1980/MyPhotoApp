//
//  LogOutScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/21/23.
//

import Foundation

@MainActor
final class LogOutScreenViewModel: LogOutScreenViewModelType {
    
    @Published var emailUser: String?
    
    init() {
        Task{
            try await getUser()
        }
    }
    
    func LogOut() throws {
        try AuthNetworkService.shared.signOut()
    }
    
    func getUser() async throws {
        let userDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        print(userDataResult.uid)
        self.emailUser = userDataResult.email
    }
    
}
