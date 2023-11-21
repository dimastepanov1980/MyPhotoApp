//
//  AuthenticationCustomerView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/19/23.
//

import SwiftUI

struct AuthenticationCustomerView<ViewModel: AuthenticationCustomerViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath

    init(with viewModel: ViewModel,
         path: Binding<NavigationPath>
    ) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
            VStack {
                Spacer()
                        CustomerTab(
                            email: Binding<String>(
                                get: { viewModel.custmerEmail },
                                set: { viewModel.setCustmerEmail($0) }),
                            password: Binding<String>(
                                get: { viewModel.custmerPassword },
                                set: { viewModel.setCustmerPassword($0) }),
                            errorMassage: viewModel.custmerErrorMessage) {
                                if !viewModel.custmerEmail.isEmpty && !viewModel.custmerPassword.isEmpty {
                                    self.viewModel.userIsCustomer = true
                                    Task {
                                        do {
                                            try await viewModel.authenticationCustomer()
                                        } catch {
                                            self.viewModel.custmerErrorMessage = error.localizedDescription
                                        }
                                    }
                                }
                            }
            }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(R.string.localizable.logIn_SignUp())
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: customBackButton)
    }
    private var customBackButton : some View {
        Button {
            path.removeLast(1)
            viewModel.showAuthenticationCustomerView = false

        } label: {
            Image(systemName: "chevron.left.circle.fill")// set image here
               .font(.title)
               .foregroundStyle(.white, Color(R.color.gray1.name).opacity(0.7))
        }
    }
    private struct CustomerTab: View {
        @Binding var email: String
        @Binding var password: String
        let errorMassage: String
        private let action: () async throws -> Void
        
        init(email: Binding<String>, password: Binding<String>, errorMassage: String, action: @escaping () async throws -> Void) {
            self._email = email
            self._password = password
            self.errorMassage = errorMassage
            self.action = action
        }
        
        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                    CustomTextField(nameTextField: R.string.localizable.email(), text: $email)
                        .padding(.bottom, 32)
                    CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
                    Text(errorMassage)
                        .font(.footnote)
                        .foregroundColor(Color(R.color.red.name))
                        .padding(.top, 32)
                
                
                Spacer()
                CustomButtonXl(titleText: R.string.localizable.customer_login(),
                         iconName: "camera.aperture") {
                    Task {
                        try await action()
                    }
                }
                         .padding(.bottom)
            }
        }
    }
}

struct AuthenticationCustomerView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()

    static var previews: some View {
        NavigationStack{
            AuthenticationCustomerView(with: modelMock, path: .constant(NavigationPath()))
        }
    }
}

private class MockViewModel: AuthenticationCustomerViewModelType, ObservableObject {
    func getUserType() async throws -> Bool {
        true
    }
    
    var showAuthenticationCustomerView: Bool = false
    var userIsCustomer: Bool = false
    
    func authenticationCustomer() async throws {}
    var custmerErrorMessage = ""
    var authorErrorMessage = ""
    var custmerEmail = ""
    var custmerPassword = ""
   
    func setCustmerEmail(_ signInEmail: String) {
        self.custmerEmail = signInEmail
    }
    func setCustmerPassword(_ signInPassword: String) {
        self.custmerPassword = signInPassword
    }
}
