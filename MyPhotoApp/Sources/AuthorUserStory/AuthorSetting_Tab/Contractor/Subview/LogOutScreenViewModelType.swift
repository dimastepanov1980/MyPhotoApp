//
//  LogOutScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/21/23.
//

import Foundation

@MainActor
protocol LogOutScreenViewModelType: ObservableObject {
    
    func LogOut() throws
}

