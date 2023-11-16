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
    @Published var avatarImage: UIImage?
    @Published var avatarAuthor: String

    @Binding var typeAuthor: String
    @Binding var nameAuthor: String
    @Binding var familynameAuthor: String
    @Binding var sexAuthor: String
    @Binding var ageAuthor: String
    @Binding var styleAuthor: [String]
    @Binding var descriptionAuthor: String
    @Binding var longitude: Double
    @Binding var latitude: Double
    @Binding var regionAuthor: String
    
    init(locationAuthor: String,
         typeAuthor: Binding<String>,
         nameAuthor: Binding<String>,
         familynameAuthor: Binding<String>,
         sexAuthor: Binding<String>,
         ageAuthor: Binding<String>,
         styleAuthor: Binding<[String]>,
         avatarAuthor: String,
         avatarImage: UIImage?,
         descriptionAuthor: Binding<String>,
         longitude: Binding<Double>,
         latitude: Binding<Double>,
         regionAuthor: Binding<String>) {
        
        self.locationAuthor = locationAuthor
        self.avatarAuthor = avatarAuthor
        self.avatarImage = avatarImage

        self._typeAuthor = typeAuthor
        self._nameAuthor = nameAuthor
        self._familynameAuthor = familynameAuthor
        self._sexAuthor = sexAuthor
        self._ageAuthor = ageAuthor
        self._styleAuthor = styleAuthor
        self._descriptionAuthor = descriptionAuthor
        self._longitude = longitude
        self._latitude = latitude
        self._regionAuthor = regionAuthor
        
        let globalCoordinate = CLLocationCoordinate2D()

        service = SearchLocationManager(in: globalCoordinate)
        self.locationResult = []
        
        cancellable = service.searchLocationPublisher.sink { mapItems in
            Task{
                self.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
            }
        }

    }

    func searchLocation(text: String) {
        service.searchLocation(searchText: text)
    }
    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws {
        do {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            try? await UserManager.shared.setUserPortfolio(userId: authDateResult.uid, portfolio: portfolio)
        } catch {
            print(error.localizedDescription)
            print(String(describing: error))
            throw error
        }
       
    }
    func addAvatar(selectImage: PhotosPickerItem?) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        guard let data = try? await selectImage?.loadTransferable(type: Data.self), let image = UIImage(data: data) else {
            throw URLError(.backgroundSessionWasDisconnected)
                 }
            let (path, _) = try await StorageManager.shared.uploadPortfolioImageDataToFairbase(data: data, userId: authDateResult.uid)
            try await UserManager.shared.addAvatarToPortfolio(userId: authDateResult.uid, path: path)
            self.avatarImage = image
    }
}
