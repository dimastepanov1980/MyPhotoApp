//
//  PortfolioViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/1/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class PortfolioViewModel: PortfolioViewModelType {
    @Published var dbModel: DBPortfolioModel?
    @Published var avatarURL: URL?
    @Published var locationAuthor: String = ""
    @Published var identifier: String = ""
    @Published var avatarAuthor: String = ""
    @Published var nameAuthor: String = ""
    @Published var familynameAuthor: String = ""
    @Published var ageAuthor: String = ""
    @Published var sexAuthor: String = ""
    @Published var styleAuthor: [String] = []
    @Published var descriptionAuthor: String = ""
    @Published var avatarAuthorID = UUID()
    @Published var typeAuthor: String = ""
    @Published var smallImagesPortfolio: [String] = []
    @Published var portfolioImages: [UIImage] = []
    
    init(dbModel: DBPortfolioModel? = nil) {
        self.dbModel = dbModel
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
            smallImagesPortfolio = dbModel.smallImagesPortfolio ?? []
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
    
    func getPortfolioImages(imagesPath: [String]) async throws {
        var portfolioImages: [UIImage] = []
        
        await withTaskGroup(of: UIImage?.self) { taskGroup in
            for imagePath in imagesPath {
                taskGroup.addTask {
                    do {
                        let image = try await StorageManager.shared.getReferenceImage(path: imagePath)
                        return image
                    } catch {
                        // Handle any errors that occur during image fetching
                        print("Error fetching image: \(error)")
                        return nil
                    }
                }
            }
            
            for await image in taskGroup {
                if let image = image {
                    portfolioImages.append(image)
                }
            }
        }
        
        self.portfolioImages = portfolioImages.compactMap { $0 }
    }
    
    func addPortfolioImages(selectedImagesData: [Data]) async throws {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            var selectedImages: [String] = []
            for data in selectedImagesData {
                let (path, _) = try await StorageManager.shared.uploadPortfolioImageDataToFairbase(data: data, userId: authDateResult.uid)
                selectedImages.append(path)
            }
            try await UserManager.shared.addPortfolioImagesUrl(userId: authDateResult.uid, path: selectedImages)
    }
    
}
