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
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    @State private var selectedAvatar: PhotosPickerItem?
    @State private var isAvatarUploadInProgress = false
    @State private var loadingImage = false
    @Binding var showAuthenticationView: Bool

    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>){
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView

    }
    
    var body: some View {
            VStack(spacing: 20){
                avatarImageSection
                CustomTextField(nameTextField: R.string.localizable.portfolio_first_name(), text: $viewModel.nameCustomer, isDisabled: false)
                CustomTextField(nameTextField: R.string.localizable.portfolio_last_name(), text: $viewModel.secondNameCustomer, isDisabled: false)
                CustomTextField(nameTextField: R.string.localizable.settings_section_profile_phone(), text: $viewModel.phone, isDisabled: false)
                    .keyboardType(.phonePad)
                CustomTextField(nameTextField: R.string.localizable.settings_section_profile_instagram(), text: $viewModel.instagramLink, isDisabled: false)
                
                Spacer()
                if user.userType != .unspecified {
                    VStack(spacing: 20){
                        Button {
                            Task {
                                do {
                                    try viewModel.LogOut()
                                    user.userType = .unspecified
                                    showAuthenticationView = true
                                    router.pop()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            ZStack {
                                Text(R.string.localizable.signOutAccBtt())
                                    .font(.headline)
                                    .foregroundColor(Color(R.color.gray6.name))
                                    .padding(8)
                                    .padding(.horizontal, 16)
                                    .background(Color(R.color.gray1.name))
                                    .cornerRadius(20)
                            }
                        }
                        Button {
                            router.push(.ReAuthenticationView)
                        } label: {
                            Text(R.string.localizable.delete_user())
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButtonView())
            .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(R.string.localizable.save()) {
                    Task {
                        let profile: DBUserModel = DBUserModel(userId: "",
                                                               firstName: viewModel.nameCustomer,
                                                               secondName: viewModel.secondNameCustomer,
                                                               instagramLink: viewModel.instagramLink,
                                                               phone: viewModel.phone,
                                                               email: "",
                                                               dateCreate: nil,
                                                               userType: nil,
                                                               setPortfolio: false)

                        try await viewModel.updateCurrentUser(profile: profile)
                        router.popToRoot()
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
                 if let avatarImage = viewModel.avatarImage {
                     Image(uiImage: avatarImage)
                         .resizable()
                         .scaledToFill()
                         .mask {
                             Circle()
                         }
                         .frame(width: 110, height: 110)
                     
                 } else {
                     ZStack{
                         Color(R.color.gray5.name)
                         Image(systemName: "arrow.triangle.2.circlepath.camera")
                             .font(.largeTitle)
                             .fontWeight(.thin)
                             .foregroundColor(Color(R.color.gray3.name))
                             
                     }
                     .mask {
                         Circle()
                     }
                     .frame(width: 110, height: 110)
                 }
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
                                      loadingImage = false
                                  } catch {
                                      print("Error uploading avatar: \(error)")
                                  }
                                  
                                  isAvatarUploadInProgress = false
                              }
                          })
                          .overlay{
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
            ProfileScreenView(with: mocData, showAuthenticationView: .constant(false))
            .environmentObject(UserTypeService())
    }
}


private class MockViewModel: ProfileScreenViewModelType, ObservableObject {
    var user: DBUserModel? = nil
    var avatarProfile: String?
    var avatarImage: UIImage?
    var nameCustomer: String = ""
    var secondNameCustomer: String = ""
    var instagramLink: String = ""
    var phone: String = ""
    
    func addAvatar(selectImage: PhotosPickerItem?) async throws {}
    func getAvatarImage(imagePath: String) async throws {}
    func loadCurrentUser() async throws {}
    func updateCurrentUser(profile: DBUserModel) async throws {}
    func LogOut() throws {}

}
