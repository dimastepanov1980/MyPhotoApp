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
    @State var reAuthenticationScreenSheet: Bool = false

    @Environment(\.dismiss) private var dismiss

    
    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView

    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Button {
                    Task {
                        do {
                            try viewModel.LogOut()
                            showAuthenticationView = true
                            dismiss()
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
                    dismiss()
                } label: {
                    Text(R.string.localizable.delete_user())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray3.name))
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .padding(.top, 16)
            .padding(.top, 64)
        }
        .sheet(isPresented: $reAuthenticationScreenSheet) {
            NavigationStack {
                ReAuthenticationScreenView(with: ReAuthenticationScreenViewModel(), showReAuthenticationView: $reAuthenticationScreenSheet, showAuthenticationView: $showAuthenticationView)
            }
        }
    }
    private var customBackButton : some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left.circle.fill")// set image here
               .font(.title)
               .foregroundStyle(.white, Color(R.color.gray1.name).opacity(0.7))
        }
    }
    }


struct LogOutScreenView_Previews: PreviewProvider {
    private static let mocData = MockViewModel()

    static var previews: some View {
        LogOutScreenView(with: mocData, showAuthenticationView: .constant(false))
    }
}

private class MockViewModel: LogOutScreenViewModelType, ObservableObject {
    func LogOut() throws {}
}
