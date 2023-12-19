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
                VStack(alignment: .leading, spacing: 12){
                    if user.userType == .unspecified {
                        SignInSignUpButton(router: _router, user: _user)
                    }
                    ForEach(viewModel.settingsMenu, id: \.self) { item in
                        HStack{
                            Image(systemName: item.imageItem)
                                .font(.title2)
                                .foregroundColor(Color(R.color.gray2.name))
                            Text(item.nameItem)
                                .font(.callout)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        .onTapGesture {
                            viewForSettingItem(item)
                        }
                        Divider()
                           
                    }
                    HStack{
                        Image(systemName: "arrow.triangle.swap")
                            .font(.title2)
                            .foregroundColor(user.userType == .unspecified ? Color(R.color.gray5.name) : Color(R.color.gray2.name))
                        Text(user.userType == .author ? R.string.localizable.settings_section_customer() : R.string.localizable.settings_section_author() )
                            .font(.callout)
                            .foregroundColor(user.userType == .unspecified ? Color(R.color.gray5.name) : Color(R.color.gray3.name))
                    }
                    .onTapGesture {
                        switch user.userType {
                        case .author:
                            user.userType = .customer
                        case .customer:
                            user.userType = .author
                        case .unspecified:
                            user.userType = .unspecified
                        }
                    }
                    .disabled(user.userType != .unspecified)
                }
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
}
