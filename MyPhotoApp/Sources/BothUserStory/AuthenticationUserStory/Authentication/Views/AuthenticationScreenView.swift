////
////  AuthenticationScreenView.swift
////  MyPhotoApp
////
////  Created by Dima Stepanov on 5/17/23.
////
//
//import SwiftUI
//
//struct AuthenticationScreenView<ViewModel: AuthenticationScreenViewModelType>: View {
//    
//    @ObservedObject private var viewModel: ViewModel
//    @EnvironmentObject var router: Router<Views>
//    @EnvironmentObject var user: UserTypeService
//
//    
//    @State var index: Int = 1
//    @Binding var showAuthenticationView: Bool
//    @State var offsetWidth: CGFloat = UIScreen.main.bounds.width
//    var width = UIScreen.main.bounds.size.width
//    var height = UIScreen.main.bounds.size.height
//    
//    init(with viewModel: ViewModel,
//         showAuthenticationView: Binding<Bool>) {
//        self.viewModel = viewModel
//        self._showAuthenticationView = showAuthenticationView
//    }
//    
//    var body: some View {
//            VStack(spacing: 0) {
//                Spacer()
//                VStack{
//                    Image(R.image.ic_logo.name)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: 80)
//                        .offset(x: -2)
//                        .padding(.bottom)
//
//                    TabName(index: self.$index, offset: self.$offsetWidth)
//                }
//                    HStack(alignment: .top, spacing: 0) {
//                        CustomerTab(
//                            email: Binding<String>(
//                                get: { viewModel.custmerEmail },
//                                set: { viewModel.setCustmerEmail($0) }),
//                            password: Binding<String>(
//                                get: { viewModel.custmerPassword },
//                                set: { viewModel.setCustmerPassword($0) }),
//                            errorMassage: viewModel.custmerErrorMessage) {
//                                if !viewModel.custmerEmail.isEmpty && !viewModel.custmerPassword.isEmpty {
////                                    self.viewModel.userIsCustomer = true
//                                    Task {
//                                        do {
//                                            try await viewModel.authenticationCustomer()
//                                            user.userType = .customer
//                                            self.showAuthenticationView = false
//                                            return
//                                        } catch {
//                                            self.viewModel.custmerErrorMessage = error.localizedDescription
//                                        }
//                                    }
//                                }
//                            } resetPassworAction: {
//                                
//                                try await viewModel.resetPassword()
//                            }
//                            .frame(width: width)
//                        
//                        AuthoTab(
//                            email: Binding<String>(
//                                get: { viewModel.authorEmail },
//                                set: { viewModel.setAuthorEmail($0) }),
//                            password: Binding<String>(
//                                get: { viewModel.authorPassword },
//                                set: { viewModel.setAuthorPassword($0) }),
//                            errorMassage: viewModel.authorErrorMessage) {
//                                if !viewModel.authorEmail.isEmpty && !viewModel.authorPassword.isEmpty {
////                                    self.viewModel.userIsCustomer = false
//                                    Task {
//                                        do {
//                                            try await viewModel.authenticationAuthor()
//                                            user.userType = .author
//                                            self.showAuthenticationView = false
//                                            return
//                                        } catch {
//                                            self.viewModel.authorErrorMessage = error.localizedDescription
//                                        }
//                                    }
//                                }
//                            } resetPassworAction: {
//                                
//                                try await viewModel.resetPassword()
//                            }
//                            .frame(width: width)
//                        
//                    }
//                    .padding(.top, 32)
//                    .offset(x: index == 1 ? width / 2 : -width / 2)
//            }
//        .toolbar {
//            ToolbarItem(placement: .destructiveAction) {
//                Button {
//                    showAuthenticationView = false
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundStyle(Color(.systemBackground), Color(R.color.gray3.name))
//                        .font(.title2)
//                        .padding(.trailing)
//                }
//            }
//            
//            ToolbarItem(placement: .principal) {
//                Text(R.string.localizable.logIn_SignUp())
//                    .font(.footnote)
//                    .foregroundColor(Color(R.color.gray3.name))
//            }
//            
//        }
////        .onAppear {
////            Task {
////                do {
////                    viewModel.userIsCustomer = try await viewModel.getUserType()
////                        self.viewModel.showAuthenticationView = false
////                        print("user is customer: \(viewModel.userIsCustomer)")
////                } catch {
////                    print("Error: \(error)")
////                    self.viewModel.showAuthenticationView = true
////                }
////            }
////        }
//    }
//
//    private struct TabName: View {
//        @Binding var index : Int
//        @Binding var offset: CGFloat
//        var width = UIScreen.main.bounds.width
//        
//        var body: some View {
//            HStack(spacing: 32) {
//                VStack(spacing: 7) {
//                    Button {
//                        self.index = 1
//                        self.offset = 0
//                    } label: {
//                        Text(R.string.localizable.customer())
//                            .foregroundColor(Color(R.color.gray1.name))
//                            .font(.body)
//                            .fontWeight(.bold)
//                    }
//                    Capsule()
//                        .fill(self.index == 1 ? Color(R.color.gray4.name) : Color.clear )
//                        .frame(width: 60, height: 2)
//                }
//                
//                VStack(spacing: 7) {
//                    Button {
//                        self.index = 2
//                        self.offset = -self.width
//                    } label: {
//                        Text(R.string.localizable.author())
//                            .foregroundColor(Color(R.color.gray1.name))
//                            .font(.body)
//                            .fontWeight(.bold)
//                    }
//                    Capsule()
//                        .fill(self.index == 2 ? Color(R.color.gray4.name) : Color.clear )
//                        .frame(width: 60, height: 2)
//                }
//            }
//        }
//    }
//    private struct CustomerTab: View {
//        @Binding var email: String
//        @Binding var password: String
//        let errorMassage: String
//        private let action: () async throws -> Void
//        private let resetPassworAction: () async throws -> Void
//        
//        init(email: Binding<String>, 
//             password: Binding<String>,
//             errorMassage: String,
//             action: @escaping () async throws -> Void,
//             resetPassworAction: @escaping () async throws -> Void)
//        {
//            self._email = email
//            self._password = password
//            self.errorMassage = errorMassage
//            self.action = action
//            self.resetPassworAction = resetPassworAction
//        }
//        
//        var body: some View {
//            VStack(spacing: 0) {
//                    CustomTextField(nameTextField: R.string.localizable.email(), text: $email, isDisabled: false)
//                        .padding(.bottom, 32)
//                        .keyboardType(.emailAddress)
//
//                    CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
//                    Text(errorMassage)
//                        .font(.footnote)
//                        .foregroundColor(Color(R.color.red.name))
//                        .padding(.top, 32)
//                
//                
//                Spacer()
//                VStack(spacing: 20){
//                    Button {
//                        Task {
//                            try await resetPassworAction()
//                        }
//                    } label: {
//                        Text(R.string.localizable.forgotPss())
//                            .font(.footnote)
//                            .foregroundColor(Color(R.color.gray3.name))
//                    }
//                    
//                    CustomButtonXl(titleText: R.string.localizable.customer_login(),
//                                   iconName: "camera.aperture") {
//                        Task {
//                            try await action()
//                        }
//                    }
//                                   .padding(.horizontal)
//                }
//                .padding(.bottom, 36)
//            }
//        }
//    }
//    private struct AuthoTab: View {
//        @Binding var email: String
//        @Binding var password: String
//        let errorMassage: String
//        private let action: () async throws -> Void
//        private let resetPassworAction: () async throws -> Void
//        
//        init(email: Binding<String>,
//             password: Binding<String>,
//             errorMassage: String,
//             action: @escaping () async throws -> Void,
//             resetPassworAction: @escaping () async throws -> Void)
//        {
//            self._email = email
//            self._password = password
//            self.errorMassage = errorMassage
//            self.action = action
//            self.resetPassworAction = resetPassworAction
//
//        }
//        
//        var body: some View {
//            VStack(spacing: 0) {
//                CustomTextField(nameTextField: R.string.localizable.email(), text: $email, isDisabled: false)
//                    .keyboardType(.emailAddress)
//                    .padding(.bottom, 32)
//
//                CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $password)
//                Text(errorMassage)
//                    .font(.footnote)
//                    .foregroundColor(Color(R.color.red.name))
//                    .padding(.top, 32)
//                    .padding(.horizontal)
//             
//                Spacer()
//                VStack(spacing: 20){
//                    Button {
//                        Task {
//                            try await resetPassworAction()
//                        }
//                    } label: {
//                        Text(R.string.localizable.forgotPss())
//                            .font(.footnote)
//                            .foregroundColor(Color(R.color.gray3.name))
//                    }
//                    
//                    CustomButtonXl(titleText: R.string.localizable.author_login(),
//                                   iconName: "camera.aperture") {
//                        Task {
//                            try await action()
//                        }
//                    }
//                                   .padding(.horizontal)
//                }
//                .padding(.bottom, 36)
//            }
//        }
//    }
//    
//}
//
//
//
//struct AuthenticationScreenView_Previews: PreviewProvider {
//    private static let modelMock = MockViewModel()
//    
//    static var previews: some View {
//        NavigationStack {
//            AuthenticationScreenView(with: modelMock, showAuthenticationView: .constant(true))
//        }
//    }
//}
//private class MockViewModel: AuthenticationScreenViewModelType, ObservableObject {
//    func getUserType() async throws -> Bool {
//        true
//    }
//    
//    var showAuthenticationView: Bool = false
//    var userIsCustomer: Bool = false
//    
//    func authenticationCustomer() async throws {}
//    var custmerErrorMessage = ""
//    var authorErrorMessage = ""
//    var custmerEmail = ""
//    var custmerPassword = ""
//    var authorEmail = ""
//    var authorPassword = ""
//    
//    func setCustmerEmail(_ signInEmail: String) {
//        self.custmerEmail = signInEmail
//    }
//    func setCustmerPassword(_ signInPassword: String) {
//        self.custmerPassword = signInPassword
//    }
//    func authenticationAuthor() async throws {}
//    func resetPassword() async throws {}
//    func setAuthorEmail(_ signUpEmail: String) {
//        self.authorEmail = signUpEmail
//    }
//    func setAuthorPassword(_ signUpPassword: String) {
//        self.authorPassword = signUpPassword
//    }
//}
