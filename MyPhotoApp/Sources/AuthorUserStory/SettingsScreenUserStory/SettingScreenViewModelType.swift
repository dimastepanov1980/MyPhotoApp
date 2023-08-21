//
//  SettingScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/1/23.
//

import Foundation

@MainActor
protocol SettingScreenViewModelType: ObservableObject {
    var user: DBUserModel? { get }
    var orders: [UserOrdersModel]? { get }
    var appVersion: String { get }
    func LogOut() throws
    func loadCurrentUser() async throws
}
