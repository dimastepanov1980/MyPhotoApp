//
//  SettingScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/27/23.
//

import SwiftUI
import Combine

struct SettingScreenView<ViewModel: SettingScreenViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var showAuthenticationView: Bool
    
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    
    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>) {
        
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 18){
                    if user.userType == .unspecified {
                        SignInSignUpButton(router: _router, user: _user)
                            .padding(.bottom)
                    }
                    ForEach(viewModel.settingsMenu, id: \.self) { item in
                        Button(action: {
                            viewForSettingItem(item)

                        }, label: {
                            HStack{
                                Image(systemName: item.imageItem)
                                    .font(.title2)
                                    .foregroundColor(Color(R.color.gray2.name))
                                Text(item.nameItem)
                                    .font(.callout)
                                    .foregroundColor(Color(R.color.gray3.name))
                            }
                        })
                        
                        Divider()
                           
                    }
                    Button(action: {
                        print(user.userType)
                        switch user.userType {
                        case .author:
                            Task{
                                try await viewModel.updateUserType(userTupe: "customer")
                                user.userType = .customer
                            }
                        case .customer:
                            Task{
                                try await viewModel.updateUserType(userTupe: "author")
                                user.userType = .author
                            }
                        case .unspecified:
                            return
                        }
                    }, label: {
                        HStack{
                            Image(systemName: "arrow.triangle.swap")
                                .font(.title2)
                                .foregroundColor(user.userType == .unspecified ? Color(R.color.gray5.name) : Color(R.color.gray2.name))
                            Text(user.userType == .author ? R.string.localizable.settings_section_customer() : R.string.localizable.settings_section_author() )
                                .font(.callout)
                                .foregroundColor(user.userType == .unspecified ? Color(R.color.gray5.name) : Color(R.color.gray3.name))
                        }
                    })
                    .disabled(user.userType == .unspecified)
                }
                .padding(.top)
                .padding(.horizontal, 32)
            }
        .frame(maxHeight: .infinity, alignment: .center)
        .navigationTitle(R.string.localizable.settings_name_screen())
        .background(Color(.systemBackground))
        .scrollContentBackground(.hidden)
        
    }
        private func viewForSettingItem(_ item: SettingItem) {
        switch item.nameItem {
        case R.string.localizable.settings_section_profile():
            router.push(.ProfileScreenView)
        case R.string.localizable.settings_section_notification():
            NotificationScreenView()
        case R.string.localizable.settings_section_privacy():
            PrivacyScreenView()
        case R.string.localizable.settings_section_information():
            router.push(.InformationScreenView)
        case R.string.localizable.settings_section_localization():
            LocalizationScreenView()
        default:
            router.push(.EmptyView)
        }
    }
    
    
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        NavigationStack{
            SettingScreenView(with: viewModel, showAuthenticationView: .constant(false))
                .environmentObject(UserTypeService())

        }
    }
}

private class MockViewModel: SettingScreenViewModelType, ObservableObject {
    var userIsAuth: Bool = false
    var settingsMenu: [SettingItem] = [
        .init(imageItem: "person.circle", nameItem: R.string.localizable.settings_section_profile()),
//        .init(imageItem: "bell.circle", nameItem: R.string.localizable.settings_section_notification()),
//        .init(imageItem: "lock.circle", nameItem: R.string.localizable.settings_section_privacy()),
      .init(imageItem: "info.circle", nameItem: R.string.localizable.settings_section_information())
//      .init(imageItem: "globe", nameItem: R.string.localizable.settings_section_localization()),
]
    var appVersion: String = "1.2"
    func updateUserType(userTupe: String) async throws {}
}
