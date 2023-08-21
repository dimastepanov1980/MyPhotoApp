//
//  LoginView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI

struct AuthScreenView<ViewModel: AuthScreenViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @Binding var showSignInView: Bool
    @State var index : Int = 1
    @State var offsetWidth: CGFloat = UIScreen.main.bounds.width
    var width = UIScreen.main.bounds.size.width
    var height = UIScreen.main.bounds.size.height
    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool> ) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Image(R.image.image_logo.name)
                    .padding(.top, height / 8)
                Spacer()
                TabName(index: self.$index, offset: self.$offsetWidth)
                    .padding(.top, height / 9)
                
                HStack(alignment: .top, spacing: 0) {
                    RegistrationTab(
                        email: Binding<String>(
                            get: { viewModel.signInEmail },
                            set: { viewModel.setSignInEmail($0) }),
                        password: Binding<String>(
                            get: { viewModel.signInPassword },
                            set: { viewModel.setSignInPassword($0) }),
                        errorMassage: viewModel.errorMessage) {
                            if !viewModel.signInEmail.isEmpty && !viewModel.signInPassword.isEmpty {
                                Task {
                                    do {
                                        try await viewModel.registrationUser()
                                        showSignInView = false
                                        return
                                    } catch {
                                        self.viewModel.errorMessage = error.localizedDescription
                                    }
                                }
                            }
                        }
                        .frame(width: width)
                    
                    LoginTab(
                        email: Binding<String>(
                            get: { viewModel.signUpEmail },
                            set: { viewModel.setSignUpEmail($0) }),
                        password: Binding<String>(
                            get: { viewModel.signUpPassword },
                            set: { viewModel.setSignUpPassword($0) }),
                        errorMassage: viewModel.errorMessage) {
                            if !viewModel.signUpEmail.isEmpty && !viewModel.signUpPassword.isEmpty {
                                Task {
                                    do {
                                        try await viewModel.loginUser()
                                        showSignInView = false
                                        return
                                    } catch {
                                        self.viewModel.errorMessage = error.localizedDescription
                                    }
                                }
                            }
                        }
                        .frame(width: width)
                    
                }
                .padding(.top, 32)
                .offset(x: index == 1 ? width / 2 : -width / 2)
            }
            Spacer()
            if index == 2 {
                Button {
                    Task {
                        try await viewModel.resetPassword()
                    }
                } label: {
                    Text(R.string.localizable.forgotPss())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray3.name))
                }.padding(.bottom, 80)
            }
        }
    }
    
    private struct TabName: View {
        @Binding var index : Int
        @Binding var offset: CGFloat
        var width = UIScreen.main.bounds.width
        
        var body: some View {
            HStack(spacing: 32) {
                VStack(spacing: 7) {
                    Button {
                        self.index = 1
                        self.offset = 0
                    } label: {
                        Text(R.string.localizable.registration())
                            .foregroundColor(Color(R.color.gray1.name))
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    Capsule()
                        .fill(self.index == 1 ? Color(R.color.gray4.name) : Color.clear )
                        .frame(width: 60, height: 2)
                }
                
                VStack(spacing: 7) {
                    Button {
                        self.index = 2
                        self.offset = -self.width
                    } label: {
                        Text(R.string.localizable.logIn())
                            .foregroundColor(Color(R.color.gray1.name))
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    Capsule()
                        .fill(self.index == 2 ? Color(R.color.gray4.name) : Color.clear )
                        .frame(width: 60, height: 2)
                }
            }
        }
    }
    private struct RegistrationTab: View {
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
                    CustomTextField(nameTextField: R.string.localizable.email(), text: $email)
                        .padding(.bottom, 32)
                    CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
                    Text(errorMassage)
                        .font(.footnote)
                        .foregroundColor(Color(R.color.red.name))
                        .padding(.top, 32)
                
                
                Spacer()
                CustomButtonXl(titleText: R.string.localizable.createAccBtt(),
                         iconName: "camera.aperture") {
                    Task {
                        try await action()
                    }
                }
            }
        }
    }
    private struct LoginTab: View {
        @Binding var email: String
        @Binding var password: String
        let errorMassage: String
        private let action: () async throws -> Void
        
        init(email: Binding<String>,
             password: Binding<String>,
             errorMassage: String,
             action: @escaping () async throws -> Void
        ) {
            self._email = email
            self._password = password
            self.errorMassage = errorMassage
            self.action = action
        }
        
        var body: some View {
            VStack(spacing: 0) {
                CustomTextField(nameTextField: R.string.localizable.email(), text: $email)
                    .padding(.bottom, 32)

                CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
                Text(errorMassage)
                    .font(.footnote)
                    .foregroundColor(Color(R.color.red.name))
                    .padding(.top, 32)
                    .padding(.horizontal)
             
                Spacer()
                CustomButtonXl(titleText: R.string.localizable.signInAccBtt(),
                         iconName: "camera.aperture") {
                    Task {
                        try await action()
                    }
                }
            }
        }
    }
    
}

struct AuthScreenView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()
    
    static var previews: some View {
        NavigationStack {
            AuthScreenView(with: modelMock, showSignInView: .constant(false))
        }
    }
}
private class MockViewModel: AuthScreenViewModelType, ObservableObject {
    var errorMessage = ""
    var signInEmail = ""
    var signInPassword = ""
    var signUpEmail = ""
    var signUpPassword = ""
    
    func setSignInEmail(_ signInEmail: String) {
        self.signInEmail = signInEmail
    }
    func setSignInPassword(_ signInPassword: String) {
        self.signInPassword = signInPassword
    }
    func registrationUser() async throws {
        //
    }
    func resetPassword() async throws {
        //
    }
    func setSignUpEmail(_ signUpEmail: String) {
        self.signUpEmail = signUpEmail
    }
    func setSignUpPassword(_ signUpPassword: String) {
        self.signUpPassword = signUpPassword
    }
    func loginUser() {
        //
    }
}
