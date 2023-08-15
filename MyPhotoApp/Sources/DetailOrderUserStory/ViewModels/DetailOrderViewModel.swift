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
    @Published var imageURLs: [URL] = []

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
        updateStatus()
        Task {
           try? await fetchImageURL(imageUrlArray: order.imageUrl ?? [])
        }
    }
    
//    func updatePreview() {
//        status = order.status ?? ""
//    }
    
    private func updateStatus() {
        switch order.status {
        case "Upcoming":
            status = R.string.localizable.status_upcoming()
        case "In progress":
            status = R.string.localizable.status_inProgress()
        case "Completed":
            status = R.string.localizable.status_completed()
        case "Canceled":
            status = R.string.localizable.status_canceled()
        default:
            status = R.string.localizable.status_upcoming()
        }
    }
    
    func returnedStatus(status: String) -> String {
           switch status {
           case R.string.localizable.status_upcoming():
               return "Upcoming"
           case R.string.localizable.status_inProgress():
               return "In progress"
           case R.string.localizable.status_completed():
               return "Completed"
           case R.string.localizable.status_canceled():
               return "Canceled"
           default:
               return "Upcoming"
           }
       }
    func fetchImageURL(imageUrlArray: [String]) async throws {
        var imageURL: [URL] = []

        for imagePath in imageUrlArray {
            let url = try await StorageManager.shared.getImageURL(path: imagePath)
            imageURL.append(url)
            try Task.checkCancellation()
        }
            imageURLs = imageURL
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
                let (path, _) = try await StorageManager.shared.uploadImageToFairbase(image: uiImage, userId: authDateResult.uid , orderId: order.id)
                selectedImages.append(path)
                
                try Task.checkCancellation()
            }
            try await UserManager.shared.addToImagesUrlLinks(userId: authDateResult.uid, path: selectedImages, orderId: order.id)

    }
    func removeURLSelectedImage(order: UserOrdersModel, path: URL, imagesArray: [String]) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await StorageManager.shared.removeImages(pathURL: path, order: order, userId: authDateResult.uid, imagesArray: imagesArray)
    }
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
