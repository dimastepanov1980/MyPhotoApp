//
//  SettingScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/1/23.
//

import Foundation

@MainActor
protocol SettingScreenViewModelType: ObservableObject {
    var settingsMenu: [SettingItem] { get }
    var appVersion: String { get }
    var userIsAuth: Bool { get set }
}
