//
//  LogOutScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/21/23.
//

import Foundation

@MainActor
final class LogOutScreenViewModel: LogOutScreenViewModelType {
    
    func LogOut() throws {
        try AuthNetworkService.shared.signOut()
    }
    
}
