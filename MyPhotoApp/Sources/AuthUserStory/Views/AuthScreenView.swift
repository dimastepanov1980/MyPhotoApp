//
//  LoginView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI

struct AuthScreenView<ViewModel: AuthScreenViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel

    @State var index : Int = 1
    @State var offsetWidth: CGFloat = UIScreen.main.bounds.width
    var width = UIScreen.main.bounds.size.width
    var height = UIScreen.main.bounds.size.height
    
    init(with viewModel: ViewModel) {
           self.viewModel = viewModel
       }
    
    var body: some View {
        VStack(spacing: 0) {
            
            TabName(index: self.$index, offset: self.$offsetWidth)
                .padding(.top, height / 6)
            
            
            HStack(alignment: .top, spacing: 0) {
                RegisterTab(email: viewModel.email, password: viewModel.password, action: viewModel.signIn)
                    .frame(width: width)
                SignInTab(email: viewModel.email, password: viewModel.password, action: viewModel.signIn)
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
                    Text(R.string.localizable.register())
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
                    Text(R.string.localizable.signIn())
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


struct RegisterTab: View {
    private var email: String
    private var password: String
    private let action: () -> Void
    
    init(email: String, password: String, action: @escaping () -> Void) {
        self.email = email
        self.password = password
        self.action = action
    }
    
    var body: some View {
        VStack {
            MainTextField(nameTextField: R.string.localizable.email(), text: email)
            SecureTextField(nameSecureTextField: R.string.localizable.password(), text: password)
            Spacer()
            ButtonXl(titleText: R.string.localizable.createAccBtt(), iconName: "camera.aperture") {
                action()
                print("Register in Progress")
            }
        }
    }
}

struct SignInTab: View {
    private var email: String
    private var password: String
    private let action: () -> Void
    
    init(email: String, password: String, action: @escaping () -> Void) {
        self.email = email
        self.password = password
        self.action = action
    }
    
    var body: some View {
        VStack {
            MainTextField(nameTextField: R.string.localizable.email(), text: email)
            SecureTextField(nameSecureTextField: R.string.localizable.password(), text: password)

            Button {
                // Action
                print("Foreget password")
            } label: {
                Text(R.string.localizable.forgotPss())
            }
            
            Spacer()
            
            ButtonXl(titleText: R.string.localizable.signIn(), iconName: "camera.aperture") {
                action()
                print("SignIn in Progress")
            }
        }
    }
}

struct AuthScreenView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()

    static var previews: some View {
        AuthScreenView(with: modelMock)
    }
}

private class MockViewModel: AuthScreenViewModelType, ObservableObject {
    
    func signIn() {
        print("SignIn in Progress")
    }
    
    @Published var email = ""
    @Published var password = ""
}

