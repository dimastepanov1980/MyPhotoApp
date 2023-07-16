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
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var setImage: [Data] = []
    @Published var selectImages: [UIImage] = []
    @Published var order: UserOrdersModel
    @Published var avaibleStatus: [String] = [R.string.localizable.status_upcoming(),
                                              R.string.localizable.status_inProgress(),
                                              R.string.localizable.status_completed(),
                                              R.string.localizable.status_canceled()]
    @Published var status: String = ""
    
    var statusColor: Color {
        switch status {
        case R.string.localizable.status_upcoming():
            return Color(R.color.upcoming.name)
        case R.string.localizable.status_inProgress():
            return Color(R.color.inProgress.name)
        case R.string.localizable.status_completed():
            return Color(R.color.completed.name)
        case R.string.localizable.status_canceled():
            return Color(R.color.canceled.name)
        default:
            return Color.gray
        }
    }
    
    init(order: UserOrdersModel) {
        self.order = order
        updatePreview()
    }
    
    func updatePreview() {
        status = order.status ?? ""
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
    func updateStatus(orderModel: UserOrdersModel) async throws {
            let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.updateOrder(userId: authDateResult.uid, order: orderModel, orderId: order.id)
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
    func loadOrders(orderModel: UserOrdersModel) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.order = try await UserManager.shared.getCurrentOrders(userId: authDateResult.uid, order: orderModel)
    }
}
