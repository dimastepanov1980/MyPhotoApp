//
//  ReAuthenticationView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/13/23.
//

import SwiftUI

struct ReAuthenticationView<ViewModel: ReAuthenticationViewModelType>: View {
    @ObservedObject private var viewModel: ViewModel
    
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
                VStack {
                    Text(R.string.localizable.delete_user_allert())
                        .font(.headline)
                        .foregroundColor(Color(R.color.orange.name))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 64)
                        .padding(.horizontal, 32)
                    CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $viewModel.reSignInPassword)
                    Text(R.string.localizable.delete_user_password())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray4.name))
                        .multilineTextAlignment(.center)
                        .padding()
                    Text(viewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(Color(R.color.red.name))
                        .padding(.top, 32)
                        .padding(.horizontal)

                }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButtonView())
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, content: {
                VStack(spacing: 20){
                    CustomButtonXl(titleText: R.string.localizable.delete_user(),
                                   iconName: "exclamationmark.triangle") {
                        Task {
                            do {
                                try await viewModel.deleteUser(password: viewModel.reSignInPassword)
                                user.userType = .unspecified
                                router.popToRoot()
                            } catch {
                                self.viewModel.errorMessage = error.localizedDescription
                            }
                        }
                    }
                       .padding(.horizontal)
                }
                .padding(.bottom, 8)
            })
            
    }
}

struct ReAuthenticationView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        NavigationView {
            ReAuthenticationView(with: viewModel)
        }
    }
}

private class MockViewModel: ReAuthenticationViewModelType, ObservableObject {
    var reSignInPassword: String = ""
    var errorMessage: String = ""
    
    func deleteUser(password: String) async throws {}
}
