//
//  SignInSignUpView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/19/23.
//

import SwiftUI

struct SignInSignUpView<ViewModel: SignInSignUpViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel

    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    var authType: authType
    
    init(with viewModel: ViewModel,
         authType: authType ) {
        self.viewModel = viewModel
        self.authType = authType
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20){
                Image(R.image.ic_logo.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                Text(R.string.localizable.logo_title())
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 64)
            
            CustomTextField(nameTextField: R.string.localizable.email(), text: $viewModel.email, isDisabled: false)
                .keyboardType(.emailAddress)
            
            CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $viewModel.password)
            if authType == .signIn {
                VStack(spacing: 20) {
                    Button {
                        Task {
                            try await viewModel.resetPassword()
                        }
                    } label: {
                        Text(R.string.localizable.forgotPss())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray3.name))
                    }
                    
//                    Button {
//                        print("SignUp")
//                    } label: {
//                        Text(R.string.localizable.signup_to_continue())
//                            .font(.footnote)
//                            .foregroundColor(Color(R.color.gray3.name))
//                    }
                }
            }
            
            Text(viewModel.errorMessage)
                .font(.footnote)
                .foregroundColor(Color(R.color.red.name))
                .padding(.top, 32)
                .padding(.horizontal)
        }
//        .toolbar {
//            ToolbarItem(placement: .bottomBar) {
//                    CustomButtonXl(titleText: authType == .signIn ? R.string.localizable.signInBtn() : R.string.localizable.signUpBtn(), iconName: "camera.aperture") {
//                        Task {
//                            do {
//                                switch authType {
//                                case .signIn:
//                                    try await viewModel.signIn()
//                                    
//                                case .signUp:
//                                    try await viewModel.signUp()
//                                    
//                                }
//                                return
//                            } catch {
//                                self.viewModel.errorMessage = error.localizedDescription
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 4)
//                .buttonStyle(.plain)
//            }
//        }
        .safeAreaInset(edge: .bottom, content: {
            VStack{
                CustomButtonXl(titleText: authType == .signIn ? R.string.localizable.signInBtn() : R.string.localizable.signUpBtn(), iconName: "camera.aperture") {
                    Task {
                        do {
                            switch authType {
                            case .signIn:
                                try await viewModel.signIn()
                                
                            case .signUp:
                                try await viewModel.signUp()
                                
                            }
                            return
                        } catch {
                            self.viewModel.errorMessage = error.localizedDescription
                        }
                    }
                }
                .padding(.horizontal, 4)
                
                Button {
                    print("SignUp")
                } label: {
                    Text(R.string.localizable.signup_to_continue())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray3.name))
                }
            }
        })
        .navigationTitle(authType == .signIn ? R.string.localizable.logIn() : R.string.localizable.registration())
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
    }
    private var customBackButton : some View {
        Button {
            router.pop()
        } label: {
            Image(systemName: "chevron.left.circle.fill")// set image here
               .font(.title)
               .foregroundStyle(Color(.systemBackground), Color(R.color.gray1.name).opacity(0.5))
        }
    }
}

struct SignInSignUpView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()
    
    static var previews: some View {
        NavigationStack {
            SignInSignUpView(with: modelMock, authType: .signIn)
                .environmentObject(UserTypeService())
        }
    }
}
private class MockViewModel: SignInSignUpViewModelType, ObservableObject {
    var email: String = ""
    var password: String = ""
    var errorMessage: String = ""
    
    func signIn() async throws {}
    func signUp() async throws {}
    func resetPassword() async throws {}
}
