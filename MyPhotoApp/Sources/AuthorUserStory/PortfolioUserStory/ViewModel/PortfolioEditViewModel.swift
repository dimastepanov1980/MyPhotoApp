//
//  PortfolioEditViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/13/23.
//

import Foundation
import SwiftUI
import Combine
import MapKit
import PhotosUI

@MainActor
final class PortfolioEditViewModel: PortfolioEditViewModelType {
 
    
    @Published var service = SearchLocationManaget()
//    private var cancellable: AnyCancellable?
    
    @State var sexAuthorList = ["Select", "Male", "Female"]
    
    /*
     на 6 минуте переделать sexAuthorList
     https://youtu.be/ETS4jI0EaY4?si=yXOyKAvdDYnJZ6M4
     */
    
    @Published var locationResult = [DBLocationModel]()
    @Published var locationAuthor: String {
        didSet {
//            searchForCity(text: locationAuthor)
        }
    }
    @Published var regionAuthor: String = ""
    @Published var identifier: String = ""
    
    @Binding var typeAuthor: String
    @Binding var nameAuthor: String
    @Binding var avatarAuthorID: UUID
    @Binding var familynameAuthor: String
    @Binding var sexAuthor: String
    @Binding var avatarURL: URL?
    @Binding var ageAuthor: String
    @Binding var styleAuthor: [String]
    @Binding var avatarAuthor: String
    @Binding var descriptionAuthor: String
    
    init(locationAuthor: String,
         identifier: String,
         typeAuthor: Binding<String>,
         nameAuthor: Binding<String>,
         avatarAuthorID: Binding<UUID>,
         avatarURL: Binding<URL?>,
         familynameAuthor: Binding<String>,
         sexAuthor: Binding<String>,
         ageAuthor: Binding<String>,
         styleAuthor: Binding<[String]>,
         avatarAuthor: Binding<String>,
         descriptionAuthor: Binding<String>) {
        
        self.locationAuthor = locationAuthor
        self.identifier = identifier
        self._typeAuthor = typeAuthor
        self._nameAuthor = nameAuthor
        self._avatarAuthorID = avatarAuthorID
        self._avatarURL = avatarURL
        self._familynameAuthor = familynameAuthor
        self._sexAuthor = sexAuthor
        self._ageAuthor = ageAuthor
        self._styleAuthor = styleAuthor
        self._avatarAuthor = avatarAuthor
        self._descriptionAuthor = descriptionAuthor
        
//        cancellable = service.searchLocationPublisher.sink { mapItems in
//            self.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
//        }
    }

//    private func searchForCity(text: String) {
////        guard let locale = NSLocale.current.language.languageCode?.identifier else { return }
////        print(locale)
//        service.searchLocation(searchText: text)
//    }

    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.setUserPortfolio(userId: authDateResult.uid, portfolio: portfolio)
    }
    func addAvatar(selectImage: PhotosPickerItem?) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        
        guard let data = try? await selectImage?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        let (patch, _) = try await StorageManager.shared.uploadAvatarToFairbase(image: uiImage, userId: authDateResult.uid)
        let avatarURL = try await avatarPathToURL(path: patch)
        try await UserManager.shared.addAvatarUrl(userId: authDateResult.uid, path: avatarURL.absoluteString)

    }
    func avatarPathToURL(path: String) async throws -> URL {
        try await StorageManager.shared.getImageURL(path: path)
    }
    
}
