//
//  ProfileScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/19/23.
//

import SwiftUI
import PhotosUI

struct ProfileScreenView<ViewModel: ProfileScreenViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @State private var logoutConfirmation = false
    @State private var selectedAvatar: PhotosPickerItem?
    @State private var isAvatarUploadInProgress = false
    @State private var loadingImage = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            VStack(spacing: 20){
                avatarImageSection
                CustomTextField(nameTextField: R.string.localizable.portfolio_first_name(), text: $viewModel.nameCustomer)
                CustomTextField(nameTextField: R.string.localizable.portfolio_last_name(), text: $viewModel.secondNameCustomer)
                CustomTextField(nameTextField: R.string.localizable.settings_section_profile_email(), text: $viewModel.email)
                    .disabled(true)
                CustomTextField(nameTextField: R.string.localizable.settings_section_profile_phone(), text: $viewModel.phone)
                CustomTextField(nameTextField: R.string.localizable.settings_section_profile_instagram(), text: $viewModel.instagramLink)
                
                Spacer()
            }
            .confirmationDialog("Log Out", isPresented: $logoutConfirmation) {
                Button("Confirm") {
                    logoutConfirmation = false
                }
                Button("Cancel") {
                    logoutConfirmation = false
                }
            }
        
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(R.string.localizable.save()) {
                    Task {
                        let profile: DBUserModel = DBUserModel(userId: "",
                                                               firstName: viewModel.nameCustomer,
                                                               secondName: viewModel.secondNameCustomer,
                                                               instagramLink: viewModel.instagramLink,
                                                               phone: viewModel.phone,
                                                               email: viewModel.email,
                                                               dateCreate: nil,
                                                               userType: nil)

                        try await viewModel.updateCurrentUser(profile: profile)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .foregroundColor(Color(R.color.gray2.name))
                .padding()
            }
        }

    }
    
    private var avatarImageSection: some View {
        PhotosPicker(selection: $selectedAvatar,
                     matching: .any(of: [.images, .not(.videos)]),
                     preferredItemEncoding: .automatic,
                     photoLibrary: .shared()) {
            AsyncImage(url: URL(string: viewModel.avatarCustomer)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Color.gray.opacity(0.2)
                }
            }
            .mask {
                Circle()
            }
            .frame(width: 110, height: 110)
            .id(viewModel.avatarID)
        }
         .onChange(of: selectedAvatar, perform: { avatar in
             guard !isAvatarUploadInProgress else {
                 return
             }
             isAvatarUploadInProgress = true
             Task {
                 do {
                     withAnimation {
                         loadingImage = true
                     }
                     try await viewModel.addAvatar(selectImage: avatar)
                     viewModel.avatarID = UUID()
                     loadingImage = false
                 } catch {
                     print("Error uploading avatar: \(error)")
                 }
                 
                 isAvatarUploadInProgress = false
             }
         })
         .overlay{
             // Show a ProgressView while waiting for the photo to load
             if loadingImage {
                 ProgressView()
                     .progressViewStyle(CircularProgressViewStyle())
                     .frame(width: 110, height: 110)
                 
                     .background(Color.white.opacity(0.7))
                     .clipShape(Circle())
                     .animation(.default, value: loadingImage)
             }
         }
    }

}

struct ProfileScreenView_Previews: PreviewProvider {
    private static let mocData = MockViewModel()
    static var previews: some View {
        NavigationStack{
            ProfileScreenView(with: mocData)
        }
    }
}


private class MockViewModel: ProfileScreenViewModelType, ObservableObject {
 
    var user: DBUserModel? = nil
    var instagramLink: String = ""
    var phone: String = ""
    var email: String = ""
    var avatarURL: URL? = nil
    var avatarID: UUID = UUID()
    var dateOfBirthday: Date = Date()
    var avatarCustomer: String = ""
    var descriptionCustomer: String = ""
    var nameCustomer: String = ""
    var secondNameCustomer: String = ""
    
    func updateCurrentUser(profile: DBUserModel) async throws {}
    func addAvatar(selectImage: PhotosPickerItem?) async throws {}
    func avatarPathToURL(path: String) async throws -> URL {
        return URL(string: "")!
    }
    func loadCurrentUser() async throws -> DBUserModel {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()

        return DBUserModel(auth: autDataResult, userType: "", firstName: "", secondName: "", instagramLink: "", phone: "")
    }
    
}
