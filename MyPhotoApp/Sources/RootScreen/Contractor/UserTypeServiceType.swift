//
//  RootScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/12/23.
//

import Foundation
@MainActor
protocol UserTypeServiceType: ObservableObject {
    var userType: Constants.UserType { get set }
    
    func getUserType() async throws
    func setUserType() async throws
}
