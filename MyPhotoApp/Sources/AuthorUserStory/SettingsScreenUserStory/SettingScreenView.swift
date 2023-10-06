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
    @Binding var isShowActionSheet: Bool
    var height = UIScreen.main.bounds.size.height
    
    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>,
         isShowActionSheet: Binding<Bool>) {
        
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
        self._isShowActionSheet = isShowActionSheet
    }
    
    var body: some View {
        ZStack{
            Color(R.color.gray7.name)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Image(R.image.image_logo.name)
                    .padding(.top, height / 12)
                Text("\(R.string.localizable.app_version()) \(viewModel.appVersion)")
                    .font(.caption)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(.bottom, 36)
                Spacer()
                if let user = viewModel.user {
                    if let email = user.email {
                        Text(R.string.localizable.your_login())
                        Text("\(email)")
                            .font(.body)
                            .foregroundColor(Color(R.color.gray1.name))
                            .padding(.bottom)
                    }
                }
                Spacer()
                Link(destination: URL(string: "http://takeaphoto.app")!) {
                    VStack {
                        Text(R.string.localizable.contact_with_us())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray1.name))
                            .padding(8)
                    }
                }
                
                Text(R.string.localizable.notes())
                    .font(.caption)
                    .foregroundColor(Color(R.color.gray3.name))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)
                VStack{

                    Button {
                        Task {
                            do {
                                try viewModel.LogOut()
                                showAuthenticationView = true
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
                        isShowActionSheet.toggle()
                    } label: {
                        Text(R.string.localizable.delete_user())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray5.name))
                    }
                }
                .padding(.top, 16)
                
                
                /*
                 
                 Button {
                     showCustomerZone.toggle()
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
                 */
                
                Spacer()
            }
            .padding(.top, 64)
        }
        .fullScreenCover(isPresented: $isShowActionSheet) {
            NavigationView {
                ReAuthenticationScreenView(with: ReAuthenticationScreenViewModel(), isShowActionSheet: $isShowActionSheet, showAuthenticationView: $showAuthenticationView)
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        SettingScreenView(with: viewModel, showAuthenticationView: .constant(false), isShowActionSheet: .constant(false))
    }
}

private class MockViewModel: SettingScreenViewModelType, ObservableObject {
    var appVersion: String = "1.2"
    var orders: [UserOrdersModel]?
    var user: DBUserModel? = nil
    func loadCurrentUser() throws {}
    func LogOut() throws {}
}
