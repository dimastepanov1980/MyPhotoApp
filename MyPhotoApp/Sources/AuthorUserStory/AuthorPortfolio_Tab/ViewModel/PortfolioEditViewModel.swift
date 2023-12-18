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
    private var portfolio: AuthorPortfolioModel?

    @State var sexAuthorList = ["Select", "Male", "Female"]
    @Published var locationResult: [DBLocationModel]
    @Published var locationAuthor: String {
        didSet{
            searchLocation(text: locationAuthor)
        }
    }
    @Published var avatarImage: UIImage?
    @Published var avatarAuthor: String
    @Published var typeAuthor: String
    @Published var nameAuthor: String
    @Published var familynameAuthor: String
    @Published var sexAuthor: String
    @Published var ageAuthor: String
    @Published var styleAuthor: [String]
    @Published var descriptionAuthor: String
    @Published var longitude: Double
    @Published var latitude: Double
    @Published var regionAuthor: String
    
    init(portfolio: AuthorPortfolioModel? = nil,
         avatarImage: UIImage?
    ) {
        
        self.locationAuthor = portfolio?.author?.location ?? ""
        self.avatarAuthor = portfolio?.avatarAuthor ?? ""
        self.avatarImage = avatarImage

        self.typeAuthor = portfolio?.author?.typeAuthor ?? ""
        self.nameAuthor = portfolio?.author?.nameAuthor ?? ""
        self.familynameAuthor = portfolio?.author?.familynameAuthor ?? ""
        self.sexAuthor = portfolio?.author?.sexAuthor ?? ""
        self.ageAuthor = portfolio?.author?.ageAuthor  ?? ""
        self.styleAuthor = portfolio?.author?.styleAuthor ?? []
        self.descriptionAuthor = portfolio?.descriptionAuthor ?? ""
        self.longitude = portfolio?.author?.longitude ?? 0.0
        self.latitude = portfolio?.author?.latitude ?? 0.0
        self.regionAuthor = portfolio?.author?.regionAuthor ?? ""
        
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
