//
//  SettingScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/1/23.
//

import Foundation

@MainActor
final class SettingScreenViewModel: SettingScreenViewModelType {
    
    @Published private(set) var orders: [UserOrdersModel]? = nil
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
        self.user = try await UserManager.shared.getUser(userId: autDataResult.uid)
    }
    
    
    // TODo сделать загрузку аватарки - переделать функцию не для заказа а для пользователя
    //    func addAvatarImage(image: PhotosPickerItem) {
    //        Task {
    //            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
    //
    //            guard let data = try await image.loadTransferable(type: Data.self) else { return }
    //            let (path, name) = try await StorageManager.shared.uploadImageToFairbase(data: data, userId: authDateResult.uid, orderId: order.id)
    //            print("SUCCESS")
    //            print(name)
    //            print(path)
    //            try await UserManager.shared.addToAvatarLink(userId: authDateResult.uid, path: path, orderId: order.id)
    //        }
    //    }
}
