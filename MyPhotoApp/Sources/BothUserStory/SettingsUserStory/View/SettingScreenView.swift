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
    
    var mode: Constants.UserTypeDependencies
    
    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>,
         mode: Constants.UserTypeDependencies ) {
        
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
        self.mode = mode
    }
    
    var body: some View {
        
        VStack{
            List {
                    if !viewModel.userIsAuth {
                        VStack(alignment: .leading, spacing: 16){
                            Text(R.string.localizable.signin_to_continue())
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
//                                .padding(.bottom)
                            
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
                    
                }
                NavigationLink {
                    switch mode {
                    case .author:
                        NavigationStack {
                            CustomerPageHubView(showAuthenticationView: $showAuthenticationView)
                        }
                    case .customer:
                        NavigationStack {
                            AuthorHubPageView(showAuthenticationView: $showAuthenticationView)
                        }
                    }
                } label: {
                    Button {
                        
                    } label: {
                        HStack{
                            Image(systemName: "arrow.triangle.swap")
                                .font(.title2)
                                .foregroundColor(Color(R.color.gray2.name))
                            Text( mode == .author ? R.string.localizable.settings_section_author() : R.string.localizable.settings_section_customer() )
                                .font(.callout)
                                .foregroundColor(Color(R.color.gray3.name))
                        }

                    }
                }

            


            }
        
            
            

        }
        .frame(maxHeight: .infinity, alignment: .center)
        .navigationDestination(for: SettingItem.self) { item in
            viewForSettingItem(item)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(R.string.localizable.settings_name_screen())
                    .font(.title.bold())
                    .padding()
            }

        }
        .environment(\.defaultMinListRowHeight, 60)
        .scrollContentBackground(.hidden)
        .tint(.black)
    }
    
    @ViewBuilder
    private func viewForSettingItem(_ item: SettingItem) -> some View {
        switch item.nameItem {
        case R.string.localizable.settings_section_profile():
            ProfileScreenView(with: ProfileScreenViewModel(profileIsShow: .constant(true)))
        case R.string.localizable.settings_section_notification():
            NotificationScreenView()
        case R.string.localizable.settings_section_privacy():
            PrivacyScreenView()
        case R.string.localizable.settings_section_information():
            InformationScreenView()
        case R.string.localizable.settings_section_localization():
            LocalizationScreenView()
        case R.string.localizable.settings_section_logout():
            LogOutScreenView(with: LogOutScreenViewModel(), showAuthenticationView: $showAuthenticationView)

        default:
            Text("Unknown View")
        }
    }
    
    
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        NavigationStack{
            SettingScreenView(with: viewModel, showAuthenticationView: .constant(false), mode: .author)
        }
    }
}

private class MockViewModel: SettingScreenViewModelType, ObservableObject {
    var userIsAuth: Bool = false
    var settingsMenu: [SettingItem] = [
        .init(imageItem: "person.circle", nameItem: R.string.localizable.settings_section_profile()),
//        .init(imageItem: "bell.circle", nameItem: R.string.localizable.settings_section_notification()),
//        .init(imageItem: "lock.circle", nameItem: R.string.localizable.settings_section_privacy()),
      .init(imageItem: "info.circle", nameItem: R.string.localizable.settings_section_information()),
//      .init(imageItem: "globe", nameItem: R.string.localizable.settings_section_localization()),
        .init(imageItem: "person.crop.circle.badge.checkmark", nameItem: R.string.localizable.settings_section_logout())
]
    
    var appVersion: String = "1.2"
}
