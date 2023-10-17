//
//  SettingScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/1/23.
//

import Foundation

@MainActor
final class SettingScreenViewModel: SettingScreenViewModelType {
    
    @Published private(set) var orders: [DbOrderModel]? = nil
    @Published private(set) var user: DBUserModel? = nil
    internal var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                   return version
               } else {
                   return R.string.localizable.version_not_available()
               }
    }
    func LogOut() throws {
        try AuthNetworkService.shared.signOut()
    }
    func loadCurrentUser() async throws {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        print("loadCurrentUser: \(autDataResult)")
        let getUser = try await UserManager.shared.getUser(userId: autDataResult.uid)
        print("loadCurrentUser: \(getUser.userType)")
        self.user = getUser
    }

}
