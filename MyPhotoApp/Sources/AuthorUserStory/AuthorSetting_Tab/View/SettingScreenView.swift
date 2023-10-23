//
//  SettingScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/27/23.
//

import SwiftUI
import Combine


struct NotificationView: View {
    
    var body: some View {
        Text("NotificationView")
    }
}


struct SettingScreenView<ViewModel: SettingScreenViewModelType>: View {



    @ObservedObject var viewModel: ViewModel
    @Binding var showAuthenticationView: Bool
    @Binding var reAuthenticationScreenSheet: Bool
//.
    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>,
         reAuthenticationScreenSheet: Binding<Bool>) {
        
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
        self._reAuthenticationScreenSheet = reAuthenticationScreenSheet
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                List(viewModel.settingsMenu, id: \.self) { item in
                    NavigationLink {
                        viewForSettingItem(item)
                    } label: {
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(R.string.localizable.settings_name_screen())
                            .font(.title.bold())
                            .padding()
                    }
                }
            }
        }
            .tint(.black)
            .environment(\.defaultMinListRowHeight, 60)
            .scrollContentBackground(.hidden)
        
    }
   

    
    @ViewBuilder
    private func viewForSettingItem(_ item: SettingItem) -> some View {

        switch item.nameItem {
        case R.string.localizable.settings_section_profile():
                ProfileScreenView(with: ProfileScreenViewModel(avatarAuthorID: UUID(), dateOfBirthday: Date(), avatarAuthor: "", descriptionAuthor: ""))
        case R.string.localizable.settings_section_notification():
            NotificationScreenView()
        case R.string.localizable.settings_section_privacy():
            PrivacyScreenView()
        case R.string.localizable.settings_section_information():
            InformationScreenView()
        case R.string.localizable.settings_section_localization():
            LocalizationScreenView()
        case R.string.localizable.settings_section_logout():
            LogOutScreenView(with: LogOutScreenViewModel(), showAuthenticationView: $showAuthenticationView, reAuthenticationScreenSheet: $reAuthenticationScreenSheet)

        default:
            Text("Unknown View")
        }
    }
    
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
            SettingScreenView(with: viewModel, showAuthenticationView: .constant(false), reAuthenticationScreenSheet: .constant(false))
    }
}

private class MockViewModel: SettingScreenViewModelType, ObservableObject {
    var settingsMenu: [SettingItem] = [
        .init(imageItem: "person.circle", nameItem: R.string.localizable.settings_section_profile()),
//        .init(imageItem: "bell.circle", nameItem: R.string.localizable.settings_section_notification()),
//        .init(imageItem: "lock.circle", nameItem: R.string.localizable.settings_section_privacy()),
      .init(imageItem: "info.circle", nameItem: R.string.localizable.settings_section_information()),
//      .init(imageItem: "globe", nameItem: R.string.localizable.settings_section_localization()),
        .init(imageItem: "rectangle.portrait.and.arrow.forward", nameItem: R.string.localizable.settings_section_logout())
]
    
    var appVersion: String = "1.2"
    var user: DBUserModel? = nil
    func loadCurrentUser() throws {}
    func LogOut() throws {}
}
