//
//  ReAuthenticationScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/13/23.
//

import SwiftUI

struct ReAuthenticationScreenView<ViewModel: ReAuthenticationScreenType>: View {
    @ObservedObject private var viewModel: ViewModel
    @Binding var isShowActionSheet: Bool
    @Binding var showSignInView: Bool
    init(with viewModel: ViewModel,
         isShowActionSheet: Binding<Bool>,
         showSignInView: Binding<Bool>) {
        self.viewModel = viewModel
        self._isShowActionSheet = isShowActionSheet
        self._showSignInView = showSignInView
    }
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack {
                    Spacer()
                    Text(R.string.localizable.delete_user_allert())
                        .font(.body)
                        .foregroundColor(Color(R.color.orange.name))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 64)
                    CustomSecureTextField(nameSecureTextField: R.string.localizable.password(), text: $viewModel.reSignInPassword)
                    Text(R.string.localizable.delete_user_password())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray4.name))
                        .multilineTextAlignment(.center)
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
                                isShowActionSheet.toggle()
                                showSignInView.toggle()
                            } catch {
                                self.viewModel.errorMessage = error.localizedDescription
                            }
                        }
                    }.padding(.bottom, 32)
                }.ignoresSafeArea(.all)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowActionSheet.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }      .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationScreenView(with: AuthenticationScreenViewModel(), showSignInView: $showSignInView)
            }
        }
    }
}

struct ReAuthenticationScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        NavigationView {
            ReAuthenticationScreenView(with: viewModel, isShowActionSheet: .constant(false), showSignInView: .constant(true))
        }
    }
}

private class MockViewModel: ReAuthenticationScreenType, ObservableObject {
    var reSignInPassword: String = ""
    var errorMessage: String = ""
    
    func deleteUser(password: String) async throws {}
}
