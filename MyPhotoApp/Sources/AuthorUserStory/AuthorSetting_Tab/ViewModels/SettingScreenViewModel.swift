//
//  SettingScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/1/23.
//

import Foundation

@MainActor
final class SettingScreenViewModel: SettingScreenViewModelType {
    var appVersion: String = ""
    
    @Published var settingsMenu: [SettingItem] = [SettingItem(imageItem: "person.circle", nameItem: R.string.localizable.settings_section_profile()),
//                                       SettingItem(imageItem: "bell.circle", nameItem: R.string.localizable.settings_section_notification()),
//                                       SettingItem(imageItem: "lock.circle", nameItem: R.string.localizable.settings_section_privacy()),
                                       SettingItem(imageItem: "info.circle", nameItem: R.string.localizable.settings_section_information()),
//                                       SettingItem(imageItem: "globe", nameItem: R.string.localizable.settings_section_localization()),
                                       SettingItem(imageItem: "rectangle.portrait.and.arrow.forward", nameItem: R.string.localizable.settings_section_logout())
    ]

}

struct SettingItem: Hashable {
    var imageItem: String
    var nameItem: String
}
