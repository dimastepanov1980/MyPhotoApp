//
//  LogOutScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/19/23.
//

import SwiftUI

struct LogOutScreenView<ViewModel: LogOutScreenViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @Binding var showAuthenticationView: Bool
    @Binding var reAuthenticationScreenSheet: Bool

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

       var btnBack : some View { Button(action: {
           self.presentationMode.wrappedValue.dismiss()
           }) {
                    Image(systemName: "chevron.left.circle.fill")// set image here
                       .font(.title)
                       .foregroundStyle(.white, Color(R.color.gray1.name).opacity(0.7))
           }
       }
    
    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>,
         reAuthenticationScreenSheet: Binding<Bool>) {
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
        self._reAuthenticationScreenSheet = reAuthenticationScreenSheet

    }

    var body: some View {
        
         VStack(spacing: 20){
            Button {
                Task {
                    do {
                        try viewModel.LogOut()
                        showAuthenticationView = true
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                ZStack {
                    Text(R.string.localizable.signOutAccBtt())
                        .font(.headline)
                        .foregroundColor(Color(R.color.gray6.name))
                        .padding(8)
                        .padding(.horizontal, 16)
                        .background(Color(R.color.gray1.name))
                        .cornerRadius(20)
                }
            }

            Button {
                reAuthenticationScreenSheet.toggle()
            } label: {
                Text(R.string.localizable.delete_user())
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray3.name))
            }
             
        }
         .navigationBarBackButtonHidden(true)
         .navigationBarItems(leading: btnBack)
        .padding(.top, 16)
        .padding(.top, 64)
        .fullScreenCover(isPresented: $reAuthenticationScreenSheet) {
            NavigationStack {
                ReAuthenticationScreenView(with: ReAuthenticationScreenViewModel(), isShowActionSheet: $reAuthenticationScreenSheet, showAuthenticationView: $showAuthenticationView)
            }
        }
    }
        
    }


struct LogOutScreenView_Previews: PreviewProvider {
    private static let mocData = MockViewModel()

    static var previews: some View {
        LogOutScreenView(with: mocData, showAuthenticationView: .constant(false), reAuthenticationScreenSheet: .constant(false))
    }
}

private class MockViewModel: LogOutScreenViewModelType, ObservableObject {
    func LogOut() throws {}
}
