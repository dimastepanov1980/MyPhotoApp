//
//  SettingScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/27/23.
//

import SwiftUI


@MainActor
protocol SettingScreenViewModelType: ObservableObject {
    var user: DBUser? { get }
    func LogOut() throws
    func loadCurrentUser() async throws
    
}

@MainActor
final class SettingScreenViewModel: SettingScreenViewModelType {
    
    @Published private(set) var user: DBUser? = nil
    
     func LogOut() throws {
        try AuthNetworkService.shared.signOut()
    }
    
    func loadCurrentUser() async throws {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.user = try await UserManager.shared.getUser(userId: autDataResult.uid)
    }
}


struct SettingScreenView<ViewModel: SettingScreenViewModelType>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var showSignInView: Bool
    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
    }
    
    
    var body: some View {
            VStack{
                List {
                    if let user = viewModel.user {
                        Text("UserID \(user.userId)")
                        
                        if let email = user.email {
                            Text("email \(email)")
                        }
                        if let description = user.description {
                            Text("description \(description)")
                        }
                        if let photoURL = user.photoURL {
                            Text("photoURL \(photoURL)")
                        }
                    }
                   
                    
                }.task {
                    try? await viewModel.loadCurrentUser()
                }
                
                ButtonXl(titleText: R.string.localizable.signOutAccBtt(), iconName: "camera.aperture") {
                    Task {
                        do {
                            try viewModel.LogOut()
                            showSignInView = true
                        } catch {
                            //
                        }
                    }
                }
            }
    }
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        SettingScreenView(with: viewModel, showSignInView: .constant(false))
    }
}

private class MockViewModel: SettingScreenViewModelType, ObservableObject {
    var user: DBUser? = nil
    
    func loadCurrentUser() throws {
        //
    }
    func LogOut() throws {
        //
    }
}
