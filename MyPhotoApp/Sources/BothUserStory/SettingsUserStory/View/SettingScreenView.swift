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
        
        VStack{
            List {
                if user.userType == .unspecified {
                        VStack(alignment: .leading, spacing: 16){
                            Text(R.string.localizable.signin_to_continue())
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                            
                            CustomButtonXl(titleText: R.string.localizable.logIn(), iconName: "lock") {
                                showAuthenticationView = true
                            }
                            .padding(.bottom, 8)

                           
                                Button {
                                    showAuthenticationView = true
                                } label: {
                                    HStack{
                                        Text(R.string.localizable.signup_to_continue())
                                            .font(.subheadline)
                                            .foregroundColor(Color(R.color.gray3.name))
                                        Text(R.string.localizable.registration())
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(R.color.gray3.name))
                                    }
                                    .padding(.bottom, 8)
                                }
                        }
                    }
                ForEach(viewModel.settingsMenu, id: \.self) { item in
                    NavigationLink(value: item) {
                        HStack{
                            Image(systemName: item.imageItem)
                                .font(.title2)
                                .foregroundColor(Color(R.color.gray2.name))
                            Text(item.nameItem)
                                .font(.callout)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                    }
                        
                        .onTapGesture {
                            viewForSettingItem(item)
                        }
                }
                
                    HStack{
                        Image(systemName: "arrow.triangle.swap")
                            .font(.title2)
                            .foregroundColor(Color(R.color.gray2.name))
                        Text( user.userType == .author ? R.string.localizable.settings_section_author() : R.string.localizable.settings_section_customer() )
                            .font(.callout)
                            .foregroundColor(Color(R.color.gray3.name))
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
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(R.string.localizable.settings_name_screen())
                    .font(.title.bold())
                    .padding()
            }

        }
        .navigationBarBackButtonHidden(true)
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
