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
        VStack(spacing: 0) {
            Spacer()
            TabName(index: self.$index, offset: self.$offsetWidth)
                .padding(.top, height / 6)
            
            HStack(alignment: .top, spacing: 0) {
                
                RegistrationTab(
                    email: Binding<String>(
                        get: { viewModel.signInEmail },
                        set: { viewModel.setSignInEmail($0) }),
                    password: Binding<String>(
                        get: { viewModel.signInPassword },
                        set: { viewModel.setSignInPassword($0) })) {
                            Task {
                                do {
                                    try await viewModel.registrationUser()
                                    showSignInView = false
                                    return
                                } catch {
                                    print(error)
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
                        set: { viewModel.setSignUpPassword($0) })) {
                            Task {
                                do {
                                    try await viewModel.loginUser()
                                    showSignInView = false
                                    print("Login succsessful")
                                    return
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        .frame(width: width)
                
            } .padding(.top, height / 6)
                .offset(x: index == 1 ? width / 2 : -width / 2)
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
                            .font(.title)
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
                            .font(.title)
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
        private let action: () async throws -> Void
        
        init(email: Binding<String>, password: Binding<String>, action: @escaping () async throws -> Void) {
            self._email = email
            self._password = password
            self.action = action
        }
        
        var body: some View {
            VStack {
                CustomTextField(nameTextField: R.string.localizable.email(), text: $email)
                CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
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
        private let action: () async throws -> Void
        
        init(email: Binding<String>, password: Binding<String>, action: @escaping () async throws -> Void) {
            self._email = email
            self._password = password
            self.action = action
        }
        
        var body: some View {
            VStack {
                CustomTextField(nameTextField: R.string.localizable.email(), text: $email)
                CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
                Button {
                    // https://youtu.be/jlC1yjVTMtA?t=837
                    // https://console.firebase.google.com/u/0/project/takeaphoto-937ae/authentication/emails
                    print("Foreget password")
                } label: {
                    Text(R.string.localizable.forgotPss())
                }
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
