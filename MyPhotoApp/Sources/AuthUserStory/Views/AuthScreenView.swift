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
                
                SignInTab(email: Binding<String>(
                    get: { viewModel.signInEmail },
                    set: { viewModel.setSignInEmail($0) }),
                          password: Binding<String>(
                            get: { viewModel.signInPassword },
                            set: { viewModel.setSignInPassword($0) })) {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                    }
                }
                          .frame(width: width)
                
                SignUpTab(email: Binding<String>(
                    get: { viewModel.signUpEmail },
                    set: { viewModel.setSignUpEmail($0) }),
            password: Binding<String>(
                get: { viewModel.signUpPassword },
                set: { viewModel.setSignUpPassword($0) }), action: viewModel.signUp)
                    .frame(width: width)
                
            } .padding(.top, height / 6)
                .offset(x: index == 1 ? width / 2 : -width / 2)
        }
    }
}

struct TabName: View {
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
                    Text(R.string.localizable.signIn())
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
                    Text(R.string.localizable.signUp())
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
struct SignInTab: View {
    @Binding var email: String
    @Binding var password: String
    private let action: () async throws -> Void
    
    init(email: Binding<String>, password: Binding<String>, action: @escaping () -> Void) {
        self._email = email
        self._password = password
        self.action = action
    }
    
    var body: some View {
        VStack {
            MainTextField(nameTextField: R.string.localizable.email(), text: $email)
            SecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
            Spacer()
            ButtonXl(titleText: R.string.localizable.createAccBtt(),
                     iconName: "camera.aperture") {
                Task {
                    try await action()
                }
            }
        }
    }
}
struct SignUpTab: View {
    @Binding var email: String
    @Binding var password: String
    private let action: () -> Void
    
    init(email: Binding<String>, password: Binding<String>, action: @escaping () -> Void) {
        self._email = email
        self._password = password
        self.action = action
    }
    
    var body: some View {
        VStack {
             MainTextField(nameTextField: R.string.localizable.email(), text: $email)
             SecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
            
            Button {
                // Action
                print("Foreget password")
            } label: {
                Text(R.string.localizable.forgotPss())
            }
            
            Spacer()
            
            ButtonXl(titleText: R.string.localizable.signUp(), iconName: "camera.aperture") {
                action()
                print("SignUp in Progress")
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
    func signIn() async throws {
        //
    }
    
    func setSignUpEmail(_ signUpEmail: String) {
        self.signUpEmail = signUpEmail
    }
    func setSignUpPassword(_ signUpPassword: String) {
        self.signUpPassword = signUpPassword
    }
    func signUp() {
        //
    }
}
