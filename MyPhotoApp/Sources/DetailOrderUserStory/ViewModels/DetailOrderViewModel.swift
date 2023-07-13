//
//  DetailOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

@MainActor
final class DetailOrderViewModel: DetailOrderViewModelType {
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var setImage: [Data] = []
    @Published var selectImages: [UIImage] = []
    @Published var order: UserOrdersModel
    @Published var avaibleStatus: [String] = ["Upcoming", "In progress", "Completed"]

    init(order: UserOrdersModel) {
        self.order = order
    }

    func fetchImages() async throws {
        if let imageUrl = order.imageUrl {
            for image in imageUrl {
                let image = try await StorageManager.shared.getReferenceImage(path: image)
                selectImages.append(image)
                try Task.checkCancellation()
            }
        }
    }
    
    
    
    func updateStatus(orderModel: UserOrdersModel, status: String) async throws {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try await UserManager.shared.updateStatus(userId: authDateResult.uid, order: orderModel, orderId: order.id)
    }
    
    func addReferenceUIImages(selectedItems: [PhotosPickerItem]) async throws {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
            var selectedImages: [String] = []
            for item in selectedItems {
                
                guard let data = try? await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) else {
                    throw URLError(.backgroundSessionWasDisconnected)
                }
                print("Not compressed size\(data)")
                let (path, _) = try await StorageManager.shared.uploadImageToFairbase(image: uiImage, userId: authDateResult.uid , orderId: order.id)
                selectedImages.append(path)
                
                try Task.checkCancellation()
            }
            try await UserManager.shared.addToImagesUrlLinks(userId: authDateResult.uid, path: selectedImages, orderId: order.id)

    }
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
