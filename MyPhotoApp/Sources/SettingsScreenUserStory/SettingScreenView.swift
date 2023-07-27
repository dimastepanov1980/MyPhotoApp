//
//  SettingScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/27/23.
//

import SwiftUI
import Combine
import PhotosUI


@MainActor
protocol SettingScreenViewModelType: ObservableObject {
    var user: DBUserModel? { get }
    var orders: [UserOrdersModel]? { get }
    var appVersion: String { get }
    func LogOut() throws
    func loadCurrentUser() async throws
}

@MainActor
final class SettingScreenViewModel: SettingScreenViewModelType {
    
    @Published private(set) var orders: [UserOrdersModel]? = nil
    @Published private(set) var user: DBUserModel? = nil
    internal var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                   return version
               } else {
                   return "Version not available"
               }
    }
    
    func LogOut() throws {
        try AuthNetworkService.shared.signOut()
    }
    
    func loadCurrentUser() async throws {
        let autDataResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.user = try await UserManager.shared.getUser(userId: autDataResult.uid)
    }
    
    
    // TODo сделать загрузку аватарки - переделать функцию не для заказа а для пользователя
    //    func addAvatarImage(image: PhotosPickerItem) {
    //        Task {
    //            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
    //
    //            guard let data = try await image.loadTransferable(type: Data.self) else { return }
    //            let (path, name) = try await StorageManager.shared.uploadImageToFairbase(data: data, userId: authDateResult.uid, orderId: order.id)
    //            print("SUCCESS")
    //            print(name)
    //            print(path)
    //            try await UserManager.shared.addToAvatarLink(userId: authDateResult.uid, path: path, orderId: order.id)
    //        }
    //    }
}


struct SettingScreenView<ViewModel: SettingScreenViewModelType>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var showSignInView: Bool
    var height = UIScreen.main.bounds.size.height

    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
    }

    
    var body: some View {
        VStack{
            Image(R.image.image_logo.name)
                .padding(.top, height / 12)
            Text("App version: \(viewModel.appVersion)")
                .font(.caption)
                .foregroundColor(Color(R.color.gray3.name))
                .padding(.bottom, 36)
            Spacer()
                if let user = viewModel.user {
                    if let email = user.email {
                        Text("Your Account")
                        Text("\(email)")
                            .font(.body)
                            .foregroundColor(Color(R.color.gray1.name))
                            .padding(.bottom)
                    }
                    if let photoURL = user.photoURL {
                        Text("photoURL \(photoURL)")
                    }
                }
            Spacer()
            Link(destination: URL(string: "https://patreon.com/TakeAPhoto?utm_medium=clipboard_copy&utm_source=copyLink&utm_campaign=creatorshare_creator&utm_content=join_link")!) {
                VStack {
                    Text("Support us")
                        .font(.caption)
                        .foregroundColor(Color(R.color.gray3.name))
                        Image(R.image.image_pateron.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                }
            }
            
            Text("""
                 When we subscribe more than 100 photographers,
                 we will start to develop a portfolio service
                """)
                .font(.caption)
                .foregroundColor(Color(R.color.gray3.name))
                .multilineTextAlignment(.center)
         
            
            
            CustomButtonXl(titleText: R.string.localizable.signOutAccBtt(), iconName: "camera.aperture") {
                Task {
                    do {
                        try viewModel.LogOut()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Spacer()
        }.padding(.top, 64)
            .task {
                try? await viewModel.loadCurrentUser()
                
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
    var appVersion: String = "1.2"
    
    var orders: [UserOrdersModel]?
    
    
    var user: DBUserModel? = nil
    
    func loadCurrentUser() throws {
        //
    }
    func LogOut() throws {
        //
    }
}
