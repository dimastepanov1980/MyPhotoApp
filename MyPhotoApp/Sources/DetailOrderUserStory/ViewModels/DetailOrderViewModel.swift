//
//  DetailOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class DetailOrderViewModel: DetailOrderViewModelType {
    var name = ""
    var instagramLink: String?
    var price: Int?
    var place: String?
    var description: String?
    var duration = ""
    var image: [String]?
    var date: Date = Date()
    var images: [ImageModel] = []

    private let order: UserOrdersModel

    init(order: UserOrdersModel) {
        self.order = order
        updatePreview()
    }
    
    func updatePreview() {
        name = order.name ?? ""
        instagramLink = order.instagramLink
        price = order.price
        place = order.location
        description = order.description
        duration = order.duration ?? ""
        image = order.imageUrl
        date = order.date ?? Date()
    }
    
    func addReferenceImages(images: [PhotosPickerItem]) {
        Task {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            var selectedImages: [String] = []
            for iamgeData in images {
                guard let data = try await iamgeData.loadTransferable(type: Data.self) else { return }
                let (path, _) = try await StorageManager.shared.uploadImageToFairbase(data: data, userId: authDateResult.uid, orderId: order.id)
                print("SUCCESS")
                print(path)
                selectedImages.append(path)
            }
            try await UserManager.shared.addToImagesUrlLinks(userId: authDateResult.uid, path: selectedImages, orderId: order.id)


        }
    }
    
    func addReferenceImage(image: PhotosPickerItem) {
        Task {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()

            guard let data = try await image.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.uploadImageToFairbase(data: data, userId: authDateResult.uid, orderId: order.id)
            print("SUCCESS")
            print(name)
            print(path)
            try await UserManager.shared.addToImageUrlLink(userId: authDateResult.uid, path: path, orderId: order.id)
        }
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM" // Set the desired output date format
        return dateFormatter.string(from: date)
    }
}
