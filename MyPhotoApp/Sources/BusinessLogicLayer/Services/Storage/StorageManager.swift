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
        print("\(storage)")
        print("\(path)")
        let data = try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
        return data
        
    }
    
    func getReferenceImage(path: String) async throws -> UIImage {
        let data = try await getReferenceImageData(path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
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
              let data = resizeImage.jpegData(compressionQuality: 0.3) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        print("compressed size\(data)")
        return try await uploadImageToFairbase(data: data, userId: userId, orderId: orderId)
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


