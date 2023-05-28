//
//  SettingScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/27/23.
//

import SwiftUI

protocol SettingScreenViewModelType: ObservableObject {

    func signOut() throws
}


final class SettingScreenViewModel: SettingScreenViewModelType {
    
    func signOut() throws {
        try AuthNetworkService.shared.signOut()
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
        NavigationStack {
            VStack{
                ButtonXl(titleText: R.string.localizable.signOutAccBtt(), iconName: "aperture") {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                            print("showSignInView")
                        } catch {
                            //
                        }
                    }
                }
            }
        }
    }
}

struct SettingScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    static var previews: some View {
        SettingScreenView(with: viewModel, showSignInView: .constant(true))
    }
}

private class MockViewModel: SettingScreenViewModelType, ObservableObject {

    func signOut() throws {
        //
    }

    
}
