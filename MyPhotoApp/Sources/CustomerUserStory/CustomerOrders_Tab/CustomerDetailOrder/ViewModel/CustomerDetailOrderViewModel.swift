//
//  CustomerDetailOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/17/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor

final class CustomerDetailOrderViewModel: CustomerDetailOrderViewModelType {
    
    @Published var order: DbOrderModel
    @Published var portfolioImages: [String: UIImage?] = [:]
    @Published var smallImagesPortfolio: [String] = []

    init(order: DbOrderModel){
        self.order = order
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
                        // Handle any errors that occur during image fetching
                        print("Error fetching image: \(error)")
                        return (imagePath, nil)
                    }
                }
            }
            
            for await (imagePath, image) in taskGroup {
                if let image = image {
                    portfolioImages[imagePath] = image  // Assign the image to the dictionary
                }
                semaphore.signal()  // Release access
            }
        }
        // Now portfolioImages has all the fetched images
        self.portfolioImages = portfolioImages
    }
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        var selectedImagesPath: [String] = []

        for image in selectedImages {
            if let data = try? await image.loadTransferable(type: Data.self), let image = UIImage(data: data){
                let (path, _) = try await StorageManager.shared.uploadPortfolioImageDataToFairbase(data: data, userId: authDateResult.uid)
                selectedImagesPath.append(path)

                self.portfolioImages[path] = image
            }
        }
            try await UserManager.shared.addPortfolioImagesUrl(userId: authDateResult.uid, path: selectedImagesPath)
    }
    func deletePortfolioImage(pathKey: String) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.portfolioImages.removeValue(forKey: pathKey)
        try await UserManager.shared.deletePortfolioImage(userId: authDateResult.uid, path: pathKey)

    }

    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
    
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
}
