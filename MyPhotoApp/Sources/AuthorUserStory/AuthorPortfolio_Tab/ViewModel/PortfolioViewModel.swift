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
    @Published var portfolio: AuthorPortfolioModel?

    @Published var portfolioImages: [String: UIImage?] = [:]
    @Published var avatarImage: UIImage? = nil

    
    // TODO: -- Change getAuthorPortfolio() to getPortfolioForLocation
    func getAuthorPortfolio() async throws {
        do {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            let portfolio = try await UserManager.shared.getUserPortfolio(userId: authDateResult.uid)
            let authorPortfolioModel = AuthorPortfolioModel(portfolio: portfolio)
            self.portfolio = authorPortfolioModel
        } catch {
            print(error.localizedDescription)
            print(String(describing: error))
            throw error
        }
    }
    func getPortfolioImages(imagesPath: [String]) async throws {
        var portfolioImages: [String: UIImage?] = [:]
        let semaphore = DispatchSemaphore(value: 1)  // Semaphore for synchronization
        
        await withTaskGroup(of: (String, UIImage?).self) { taskGroup in
            for imagePath in imagesPath {
                taskGroup.addTask {
                    do {
                        let image = try await StorageManager.shared.getReferenceImage(path: imagePath)
                        return (imagePath, image)
                    } catch {
                        print("Error fetching image: \(error)")
                        return (imagePath, nil)
                    }
                }
            }
            
            for await (imagePath, image) in taskGroup {
                if let image = image {
                    portfolioImages[imagePath] = image
                }
                semaphore.signal()
            }
        }
        self.portfolioImages = portfolioImages
    }
    func getAvatarImage(imagePath: String) async throws {
        print("getAvatarImage imagePath:\(imagePath)")

        self.avatarImage = try await StorageManager.shared.getReferenceImage(path: imagePath)
    }
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        var selectedImagesPath: [String] = []
        var newPortfolioPathImages: [String: UIImage] = [:]
        
        for image in selectedImages {
            if let data = try? await image.loadTransferable(type: Data.self), let image = UIImage(data: data){
                let (imageName, imagePath) = StorageManager.shared.pathAndDataToImage(userId: authDateResult.uid)
                selectedImagesPath.append(imagePath)
                newPortfolioPathImages[imageName] = image
            }
        }
        self.portfolioImages.merge(newPortfolioPathImages) { (_, newImage) in
            return newImage
        }
        do {
            try await StorageManager.shared.newUploadPortfolioImagesToFairbase(imagesPath: newPortfolioPathImages, userId: authDateResult.uid)
        } catch {
            print("Error uploading images: \(error)")

        }
       
    }
    
    func deletePortfolioImage(pathKey: String) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.portfolioImages.removeValue(forKey: pathKey)
        try await UserManager.shared.deletePortfolioImage(userId: authDateResult.uid, path: pathKey)

    }

}
