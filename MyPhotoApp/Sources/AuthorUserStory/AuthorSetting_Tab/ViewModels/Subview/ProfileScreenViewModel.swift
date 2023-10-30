//
//  ProfileScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/20/23.
//

import Foundation
import SwiftUI
import PhotosUI

final class ProfileScreenViewModel: ProfileScreenViewModelType {
    
    @Published var user: DBUserModel?
    @Published var avatarProfile: String?
    @Published var avatarImage: UIImage? = nil
    @Published var dateOfBirthday: Date?
    @Published var nameCustomer: String
    @Published var secondNameCustomer: String
    @Published var descriptionCustomer: String?
    @Published var instagramLink: String
    @Published var phone: String
    @Published var email: String
    @Binding var profileIsShow: Bool

    
    init(user: DBUserModel? = nil,  profileIsShow: Binding<Bool>) {
        self.nameCustomer = user?.firstName ?? ""
        self.secondNameCustomer = user?.secondName ?? ""
        self.instagramLink = user?.instagramLink ?? ""
        self.phone = user?.phone ?? ""
        self.email = user?.email ?? ""
        self.avatarProfile = user?.avatarUser ?? ""
        self._profileIsShow = profileIsShow
        
        Task{
            let user = try await loadCurrentUser()
            self.user = user
            self.nameCustomer = user.firstName ?? ""
            self.secondNameCustomer = user.secondName ?? ""
            self.instagramLink =  user.instagramLink ?? ""
            self.avatarProfile = user.avatarUser ?? ""
            self.phone =  user.phone ?? ""
            self.email =  user.email ?? ""
        }
    }
    
//    func addAvatar(selectImage: PhotosPickerItem?) async throws {
//        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
//
//        guard let data = try? await selectImage?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) else {
//            throw URLError(.backgroundSessionWasDisconnected)
//        }
//        let (patch, _) = try await StorageManager.shared.uploadAvatarToFairbase(image: uiImage, userId: authDateResult.uid)
//        let avatarURL = try await avatarPathToURL(path: patch)
//        try await UserManager.shared.addAvatarUrl(userId: authDateResult.uid, path: avatarURL.absoluteString)
//    }
    
    func addAvatar(selectImage: PhotosPickerItem?) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        
        guard let data = try? await selectImage?.loadTransferable(type: Data.self), let image = UIImage(data: data) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        let (path, _) = try await StorageManager.shared.uploadAvatarImageToFairbase(data: data, userId: authDateResult.uid)
        
        if user?.userType == "author"{
            try await UserManager.shared.addAvatarToAuthorProfile(userId: authDateResult.uid, path: path)
        } else {
            try await UserManager.shared.addAvatarToCustomerProfile(userId: authDateResult.uid, path: path)
        }
        self.avatarImage = image
    }

    func loadCurrentUser() async throws -> DBUserModel {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        return try await UserManager.shared.getUser(userId: autDataResult.uid)
    }
    func updateCurrentUser(profile: DBUserModel) async throws {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        try await UserManager.shared.updateProfileData(userId: autDataResult.uid, profile: profile)
    }
    func getAvatarImage(imagePath: String) async throws {
        self.avatarImage = try await StorageManager.shared.getReferenceImage(path: imagePath)
        print("getAvatarImage: \(imagePath)")
    }
}
