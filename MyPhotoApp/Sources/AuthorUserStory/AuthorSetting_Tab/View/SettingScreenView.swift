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
    @Binding var path: NavigationPath

    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>,
         path: Binding<NavigationPath>) {
        
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
        self._path = path
    }
    
    var body: some View {
        
        VStack{
            List {
                Section {
                    if !viewModel.userIsAuth {
                        VStack(alignment: .leading, spacing: 16){
                            Text(R.string.localizable.signin_to_continue())
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                                .padding(.bottom)
                            
                            CustomButtonXl(titleText: R.string.localizable.logIn(), iconName: "lock") {
                                showAuthenticationView = true
                            }
                           
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
                                }
                            Divider()
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
            ProfileScreenView(with: ProfileScreenViewModel(profileIsShow: .constant(true)), path: $path)
        case R.string.localizable.settings_section_notification():
            NotificationScreenView()
        case R.string.localizable.settings_section_privacy():
            PrivacyScreenView()
        case R.string.localizable.settings_section_information():
            InformationScreenView()
        case R.string.localizable.settings_section_localization():
            LocalizationScreenView()
        case R.string.localizable.settings_section_logout():
            LogOutScreenView(with: LogOutScreenViewModel(), showAuthenticationView: $showAuthenticationView, path: $path)

        default:
            Text("Unknown View")
        }
    }
    
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        NavigationStack{
            SettingScreenView(with: viewModel, showAuthenticationView: .constant(false), path: .constant(NavigationPath()))
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
