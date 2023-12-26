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
        
        VStack(spacing: 20){
            VStack(spacing: 20){
                Image(R.image.ic_logo.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                Text(R.string.localizable.logo_title())
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 32)
            
            CustomTextField(nameTextField: R.string.localizable.email(), text: $viewModel.email, isDisabled: false)
                .keyboardType(.emailAddress)
            
            CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $viewModel.password)
            if authType == .signIn {
                    Button {
                        Task {
                            try await viewModel.resetPassword()
                        }
                    } label: {
                        Text(R.string.localizable.forgotPss())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray3.name))
                    }
            }
            
            Text(viewModel.errorMessage)
                .font(.footnote)
                .foregroundColor(Color(R.color.red.name))
                .padding(.top, 32)
                .padding(.horizontal)
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .safeAreaInset(edge: .bottom, content: {
            VStack(spacing: 20){
                CustomButtonXl(titleText: authType == .signIn ? R.string.localizable.signInBtn() : R.string.localizable.signUpBtn(), iconName: "camera.aperture") {
                    Task {
                            switch authType {
                            case .signIn:
                                do {
                                    try await viewModel.signIn()
                                    switch viewModel.userType {
                                    case "author":
                                        print(user.userType)
                                        user.userType = .author

                                    case "customer":
                                        print(user.userType)
                                        user.userType = .customer

                                    default:
                                        user.userType = .unspecified
                                    }
                                    router.pop()
                                } catch {
                                    self.viewModel.errorMessage = error.localizedDescription
                                }
                                
                            case .signUp:
                                do {
                                try await viewModel.signUp()
                                    user.userType = .customer
                                    router.push(.ProfileScreenView)
                                } catch {
                                    self.viewModel.errorMessage = error.localizedDescription
                                }
                            }
                    }
                }
                .padding(.horizontal)
                
                if authType != .signUp {
                    Button {
                        router.push(.SignInSignUpView(authType: .signUp))
                    } label: {
                        Text(R.string.localizable.signup_to_continue())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray3.name))
                    }
                }
            }
            .padding(.bottom, 8)
        })
        .onAppear{
            print("router: \(router.paths)")
        }
        .navigationTitle(authType == .signIn ? R.string.localizable.logIn() : R.string.localizable.registration())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView())
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
    var userType: String = ""
    
    func signIn() async throws {}
    func signUp() async throws {}
    func resetPassword() async throws {}
}
