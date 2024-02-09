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
    @Published var nameCustomer: String = ""
    @Published var secondNameCustomer: String = ""
    @Published var instagramLink: String = ""
    @Published var phone: String = ""
    
    init() {
        Task{
            try await loadCurrentUser()
            updatePreview()
            try await getAvatarImage(imagePath: avatarProfile ?? "")
        }
    }
    
    func LogOut() throws {
        try AuthNetworkService.shared.signOut()
    }
    
    func addAvatar(selectImage: PhotosPickerItem?) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        
        guard let data = try? await selectImage?.loadTransferable(type: Data.self), let image = UIImage(data: data) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        let (path, _) = try await StorageManager.shared.uploadAvatarImageToFairbase(data: data, userId: authDateResult.uid)
        try await UserManager.shared.addAvatarToAuthorProfile(userId: authDateResult.uid, path: path)
        self.avatarImage = image
    }
    func loadCurrentUser() async throws {
        do {
            let autDataResult = try  AuthNetworkService.shared.getAuthenticationUser()
            self.user = try await UserManager.shared.getUser(userId: autDataResult.uid)
        } catch {
            print(error.localizedDescription)
        }
    }
    func updatePreview(){
        self.nameCustomer = user?.firstName ?? ""
        self.secondNameCustomer = user?.secondName ?? ""
        self.instagramLink = user?.instagramLink ?? ""
        self.avatarProfile = user?.avatarUser ?? ""
        self.phone =  user?.phone ?? ""
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
