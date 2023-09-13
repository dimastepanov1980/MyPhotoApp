//
//  StorageManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/6/23.
//

import Foundation
import FirebaseStorage
import UIKit


final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
 

    private init(){}
    private func userReferenceImage(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    func getReferenceImageData(path: String) async throws -> Data {
        let data = try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
        return data
    }
    func removeImages(pathURL: URL, order: UserOrdersModel, userId: String, imagesArray: [String]) async throws {
        let imageStringPath = storage.storage.reference(forURL:"\(pathURL)")
        let elementInArray = imageStringPath.fullPath
        let newImagesArray = imagesArray.filter { $0 != elementInArray }
        
        try await UserManager.shared.deleteImagesUrlLinks(userId: userId, path: newImagesArray, orderId: order.id)
        try await imageStringPath.delete()
    }
    func getImageURL(path: String)  async throws -> URL {
       try await storage.child(path).downloadURL()
    }
    func getReferenceImage(path: String) async throws -> UIImage {
        let data = try await getReferenceImageData(path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
    func uploadURLImageToFairbase(data: Data, userId: String, orderId: String) async throws -> (path: String, name: String) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpg"
        let localFile = URL(string: path)!
        let returnedMetadata = try await userReferenceImage(userId: userId).child(orderId).putFileAsync(from: localFile, metadata: metadata)
        
        guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    func uploadImageToFairbase(data: Data, userId: String, orderId: String) async throws -> (path: String, name: String) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpg"
        let returnedMetadata = try await userReferenceImage(userId: userId).child(orderId).child(path).putDataAsync(data, metadata: metadata)
        
        guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    func uploadImageToFairbase(image: UIImage, userId: String, orderId: String) async throws -> (path: String, name: String) {
        guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 1200, height: 1200)),
              let jpegData = resizeImage.jpegData(compressionQuality: 0.3) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return try await uploadImageToFairbase(data: jpegData, userId: userId, orderId: orderId)
    }
    func uploadPortfolioImageDataToFairbase(data: Data, userId: String) async throws -> (path: String, name: String) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpg"
        let returnedMetadata = try await userReferenceImage(userId: userId).child("portfolio").child(path).putDataAsync(data, metadata: metadata)
        
        guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    func uploadAvatarImageToFairbase(data: Data, userId: String) async throws -> (path: String, name: String) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let path = "\(userId)_avatar.jpg"
        let returnedMetadata = try await userReferenceImage(userId: userId).child("portfolio").child(path).putDataAsync(data, metadata: metadata)
        
        guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    func uploadAvatarToFairbase(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120)),
              let jpegData = resizeImage.jpegData(compressionQuality: 0.3) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return try await uploadAvatarImageToFairbase(data: jpegData, userId: userId)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


