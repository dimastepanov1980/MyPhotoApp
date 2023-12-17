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
    @Published var locationAuthor: String = ""
    @Published var avatarAuthor: String = ""
    @Published var nameAuthor: String = ""
    @Published var familynameAuthor: String = ""
    @Published var ageAuthor: String = ""
    @Published var sexAuthor: String = "Select"
    @Published var styleAuthor: [String] = []
    @Published var descriptionAuthor: String = ""
    @Published var typeAuthor: String = ""
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var regionAuthor = ""
    @Published var smallImagesPortfolio: [String] = []
    @Published var portfolioImages: [String: UIImage?] = [:]
    @Published var avatarImage: UIImage? = nil
    
    @Binding var portfolioIsShow: Bool
    
    init(dbModel: DBPortfolioModel? = nil,
         portfolioIsShow: Binding<Bool>) {
        self._portfolioIsShow = portfolioIsShow
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
            latitude = dbModel.author?.latitude ?? 0.0
            longitude = dbModel.author?.longitude ?? 0.0
            regionAuthor = dbModel.author?.regionAuthor ?? ""
        }
    }
    func getAuthorPortfolio() async throws {
        do {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            let portfolio = try await UserManager.shared.getUserPortfolio(userId: authDateResult.uid)
            self.dbModel = portfolio
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
