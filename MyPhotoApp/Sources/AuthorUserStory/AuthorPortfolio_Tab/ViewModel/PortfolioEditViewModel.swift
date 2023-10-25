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
 
    
    var service: SearchLocationManager
    private var cancellable: AnyCancellable?
    
    @State var sexAuthorList = ["Select", "Male", "Female"]
    @Published var locationResult: [DBLocationModel]
    @Published var locationAuthor: String {
        didSet{
            searchLocation(text: locationAuthor)
        }
    }
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
    @Binding var longitude: Double
    @Binding var latitude: Double
    @Binding var regionAuthor: String
    
    init(locationAuthor: String,
         typeAuthor: Binding<String>,
         nameAuthor: Binding<String>,
         avatarAuthorID: Binding<UUID>,
         avatarURL: Binding<URL?>,
         familynameAuthor: Binding<String>,
         sexAuthor: Binding<String>,
         ageAuthor: Binding<String>,
         styleAuthor: Binding<[String]>,
         avatarAuthor: Binding<String>,
         descriptionAuthor: Binding<String>,
         longitude: Binding<Double>,
         latitude: Binding<Double>,
         regionAuthor: Binding<String>) {
        
        self.locationAuthor = locationAuthor
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
        self._longitude = longitude
        self._latitude = latitude
        self._regionAuthor = regionAuthor
        
        // New York
//        let center = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
        let all = CLLocationCoordinate2D()

        service = SearchLocationManager(in: all)
        self.locationResult = []
        
        cancellable = service.searchLocationPublisher.sink { mapItems in
            Task{
                self.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
                print("location Result on init: \(self.locationResult)")
            }
        }
    }

    func searchLocation(text: String) {
        service.searchLocation(searchText: text)
    }

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
