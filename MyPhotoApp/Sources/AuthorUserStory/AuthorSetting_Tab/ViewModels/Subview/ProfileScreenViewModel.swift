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
    @Published var avatarURL: URL?
    @Published var avatarID: UUID
    @Published var avatarCustomer: String
    @Published var dateOfBirthday: Date
    @Published var nameCustomer: String
    @Published var secondNameCustomer: String
    @Published var descriptionCustomer: String
    @Published var instagramLink: String
    @Published var phone: String
    @Published var email: String

    
    init(user: DBUserModel? = nil, avatarURL: URL? = nil, avatarAuthorID: UUID, dateOfBirthday: Date, avatarAuthor: String, descriptionAuthor: String) {
        self.avatarURL = avatarURL
        self.avatarID = avatarAuthorID
        self.dateOfBirthday = dateOfBirthday
        self.avatarCustomer = avatarAuthor
        self.descriptionCustomer = descriptionAuthor
        self.nameCustomer = user?.firstName ?? ""
        self.secondNameCustomer = user?.secondName ?? ""
        self.instagramLink = user?.instagramLink ?? ""
        self.phone = user?.phone ?? ""
        self.email = user?.email ?? ""
        
        Task{
            let user = try await loadCurrentUser()
            self.user = user
            self.nameCustomer = user.firstName ?? ""
            self.secondNameCustomer = user.secondName ?? ""
            self.instagramLink =  user.instagramLink ?? ""
            self.phone =  user.phone ?? ""
            self.email =  user.email ?? ""
        }
    }
    
    func addAvatar(selectImage: PhotosPickerItem?) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        
        guard let data = try? await selectImage?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        let (patch, _) = try await StorageManager.shared.uploadAvatarToFairbase(image: uiImage, userId: authDateResult.uid)
        let avatarURL = try await avatarPathToURL(path: patch)
        try await UserManager.shared.addAvatarUrl(userId: authDateResult.uid, path: avatarURL.absoluteString)
    }
    func avatarPathToURL(path: String) async throws -> URL {
        try await StorageManager.shared.getImageURL(path: path)
    }
    func loadCurrentUser() async throws -> DBUserModel {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        return try await UserManager.shared.getUser(userId: autDataResult.uid)
    }
    func updateCurrentUser(profile: DBUserModel) async throws {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        try await UserManager.shared.updateProfileData(userId: autDataResult.uid, profile: profile)
    }
}
