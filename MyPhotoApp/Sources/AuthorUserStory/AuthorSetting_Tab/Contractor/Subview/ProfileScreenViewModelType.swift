//
//  ProfileScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/20/23.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
protocol ProfileScreenViewModelType: ObservableObject {
    
    var user: DBUserModel? { get set }

    var avatarProfile: String? { get set }
    var avatarImage: UIImage? { get set }

    var nameCustomer: String { get set }
    var secondNameCustomer: String { get set }
    var descriptionCustomer: String? { get set }
    var dateOfBirthday: Date? { get set }
    
    var instagramLink: String { get set }
    var phone: String { get set }
    var email: String { get set }
    var profileIsShow: Bool { get set }
    
    
    func addAvatar(selectImage: PhotosPickerItem?) async throws
    func getAvatarImage(imagePath: String) async throws
    func loadCurrentUser() async throws -> DBUserModel
    func updateCurrentUser(profile: DBUserModel) async throws


}
