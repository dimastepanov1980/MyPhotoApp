//
//  PortfolioViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/1/23.
//

import Foundation
import SwiftUI
import Combine
import MapKit
import PhotosUI


@MainActor
final class PortfolioViewModel: PortfolioViewModelType {
    @Published var avatarImageID: UUID = UUID()
    @Published var avatarURL: URL?
    @Published var locationAuthor: String = "" {
        didSet {
            searchForCity(text: locationAuthor)
        }
    }
    @Published var locationResult = [DBLocationModel]()
    var service = SearchLocationManaget()
    private var cancellable: AnyCancellable?
    @Published var selectedAvatar: PhotosPickerItem?
    @Published var avatarAuthor: String = ""
    @Published var nameAuthor: String = ""
    @Published var familynameAuthor: String = ""
    @Published var ageAuthor: String = ""
    @Published var sexAuthor: String = "Select"
    @Published var styleAuthor: [String] = []
    @Published var descriptionAuthor: String = ""
    @State var styleOfPhotography =  ["Aerial", "Architecture", "Documentary", "Event", "Fashion", "Food",
                                      "Love Story", "Macro", "People", "Pet", "Portraits", "Product", "Real Estate",
                                      "Sports", "Wedding", "Wildlife"]
    
    @State var sexAuthorList = ["Select", "Male", "Female"]
    
    @Published var dbModel: DBPortfolioModel?
    
    init(dbModel: DBPortfolioModel? = nil) {
        self.dbModel = dbModel
        Task {
            try await getAuthorPortfolio()
            updatePreview()
            self.avatarURL = try await avatarPathToURL(path: avatarAuthor)
        }
        
        cancellable = service.searchLocationPublisher.sink { mapItems in
            self.locationResult = mapItems.map({ DBLocationModel(mapItem: $0) })
        }
    }
    
    private func searchForCity(text: String) {
        service.searchLocation(searchText: text)
    }
    
    func updatePreview(){
        if let dbModel = dbModel {
            avatarAuthor = dbModel.avatarAuthor ?? ""
            nameAuthor = dbModel.author?.nameAuthor ?? ""
            familynameAuthor = dbModel.author?.familynameAuthor ?? ""
            ageAuthor = dbModel.author?.ageAuthor ?? ""
            sexAuthor = dbModel.author?.sexAuthor ?? ""
            locationAuthor = dbModel.author?.location ?? ""
            styleAuthor = dbModel.author?.styleAuthor ?? []
            descriptionAuthor = dbModel.descriptionAuthor ?? ""
        }
    }
    func getAuthorPortfolio() async throws {
        do {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            let portfolio = try await UserManager.shared.getUserPortfolio(userId: authDateResult.uid)
            print(portfolio)
            self.dbModel = portfolio
        } catch {
            print(error.localizedDescription)
            throw error
        }
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
        try await UserManager.shared.addAvatarUrl(userId: authDateResult.uid, path: patch)
        self.avatarURL = try await avatarPathToURL(path: patch)
        }
    func avatarPathToURL(path: String) async throws -> URL {
        try await StorageManager.shared.getImageURL(path: path)
    }
}
