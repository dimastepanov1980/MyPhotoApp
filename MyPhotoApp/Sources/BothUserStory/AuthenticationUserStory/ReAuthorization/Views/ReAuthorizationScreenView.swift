//
//  ReAuthenticationScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/13/23.
//

import SwiftUI

struct ReAuthenticationScreenView<ViewModel: ReAuthenticationScreenType>: View {
    @ObservedObject private var viewModel: ViewModel
    
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    @Binding var showReAuthenticationView: Bool
    @Binding var showAuthenticationView: Bool
    @State private var userIsCustomer: Bool = false

    init(with viewModel: ViewModel,
         showReAuthenticationView: Binding<Bool>,
         showAuthenticationView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showReAuthenticationView = showReAuthenticationView
        self._showAuthenticationView = showAuthenticationView
    }
    
    var body: some View {
                VStack {
                    Spacer()
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
                    Spacer()
                    CustomButtonXl(titleText: R.string.localizable.delete_user(),
                                   iconName: "exclamationmark.triangle") {
                        Task {
                            do {
                                try await viewModel.deleteUser(password: viewModel.reSignInPassword)
                                router.popToRoot()
                                user.userType = .unspecified
                                showReAuthenticationView = false
                                showAuthenticationView.toggle()
                            } catch {
                                self.viewModel.errorMessage = error.localizedDescription
                            }
                        }
                    }
                       .padding(.horizontal)
                       .padding(.bottom, 32)
                }.ignoresSafeArea(.all)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(.systemBackground), Color(R.color.gray2.name).opacity(0.6))
                            .font(.title2)
                        
                    }
                }
            }
    }
}

struct ReAuthenticationScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        NavigationView {
            ReAuthenticationScreenView(with: viewModel, showReAuthenticationView: .constant(false), showAuthenticationView: .constant(false))
        }
    }
}

private class MockViewModel: ReAuthenticationScreenType, ObservableObject {
    var reSignInPassword: String = ""
    var errorMessage: String = ""
    
    func deleteUser(password: String) async throws {}
}
