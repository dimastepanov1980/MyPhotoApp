//
//  CustomerDetailOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class CustomerDetailOrderViewModel: CustomerDetailOrderViewModelType {
    @Published var avaibleStatus: [String] = [R.string.localizable.status_upcoming(),
                                              R.string.localizable.status_inProgress(),
                                              R.string.localizable.status_completed(),
                                              R.string.localizable.status_canceled()]
    @Published var status: String = ""
    @Published var referenceImages: [String: UIImage?] = [:]
    @Published var smallReferenceImages: [String] = []


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
    
    func lacalizationStatus(orderStatus: String) {
        switch orderStatus {
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
    
    func getReferenceImages(imagesPath: [String]) async throws {
        var referenceImages: [String: UIImage?] = [:]
        let semaphore = DispatchSemaphore(value: 1)  // Semaphore for synchronization
        
        await withTaskGroup(of: (String, UIImage?).self) { taskGroup in
            for imagePath in imagesPath {
                taskGroup.addTask {
                    do {
                        let image = try await StorageManager.shared.getReferenceImage(path: imagePath)
                        print(imagePath)
                        print(image)
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
                    referenceImages[imagePath] = image  // Assign the image to the dictionary
                }
                semaphore.signal()  // Release access
            }
        }
        // Now portfolioImages has all the fetched images
        self.referenceImages = referenceImages
    }
    func addReferenceImages(selectedImages: [PhotosPickerItem], orderId: String) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        var selectedImagesPath: [String] = []

        for image in selectedImages {
            if let data = try? await image.loadTransferable(type: Data.self), let image = UIImage(data: data){
                let (path, _) = try await StorageManager.shared.uploadSampleImageDataToFirebase(data: data, userId: authDateResult.uid)
                selectedImagesPath.append(path)

                self.referenceImages[path] = image
            }
        }
        try await UserManager.shared.addSampleImageUrl(path: selectedImagesPath, orderId: orderId)
    }
    func deleteReferenceImages(pathKey: String, orderId: String) async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.referenceImages.removeValue(forKey: pathKey)
        try await UserManager.shared.deleteSampleImageUrl(path: pathKey, orderId: orderId)
        try await StorageManager.shared.deleteSampleImageDataToFirebase(path: pathKey)

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
    func openInstagramProfile(username: String) {
        guard let instagramURL = URL(string: "https://instagram.com/\(username)") else { return }
        UIApplication.shared.open(instagramURL)
    }


}
