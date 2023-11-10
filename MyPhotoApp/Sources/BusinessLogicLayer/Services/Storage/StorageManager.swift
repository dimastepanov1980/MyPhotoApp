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
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
//    func removeImages(pathURL: URL, order: DbOrderModel, userId: String, imagesArray: [String]) async throws {
//        let imageStringPath = storage.storage.reference(forURL:"\(pathURL)")
//        let elementInArray = imageStringPath.fullPath
//        let newImagesArray = imagesArray.filter { $0 != elementInArray }
//        
//        try await UserManager.shared.deleteImagesUrlLinks(userId: userId, path: newImagesArray, orderId: order.orderId)
//        try await imageStringPath.delete()
//    }

    func deletePortfolioImage(path: String, userId: String) async throws {
        let imagePath = storage.storage.reference(withPath: path)
        try await UserManager.shared.deletePortfolioImage(userId: userId, path: path)
        try await imagePath.delete()
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

    func pathAndDataToImage(userId: String) -> (imageName: String, imagePath: String) {
        let imageName = "\(UUID().uuidString).jpg"
        let imagePath = userReferenceImage(userId: userId).child("portfolio").child(imageName)
        print("Name/Path: \(imageName)/\(imagePath.fullPath)")
        return (imageName, imagePath.fullPath)
    }
    
    func newUploadPortfolioImagesToFairbase(imagesPath: [String: UIImage], userId: String) async throws {
        for (name, image) in imagesPath {
            guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 800, height: 800)),
                  let jpegData = resizeImage.jpegData(compressionQuality: 0.8) else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let fullPathImage = userReferenceImage(userId: userId).child("portfolio").child(name)
            
            try await fullPathImage.putDataAsync(jpegData, metadata: metadata)

        }
    }
    func uploadPortfolioImageDataToFairbase(data: Data, userId: String) async throws -> (path: String, name: String) {
        if let image = UIImage(data: data) {
            guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 800, height: 800)),
                  let jpegData = resizeImage.jpegData(compressionQuality: 0.8) else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let path = "\(UUID().uuidString).jpg"
            let fullPathImage = userReferenceImage(userId: userId).child("portfolio").child(path)
            let returnedMetadata = try await fullPathImage.putDataAsync(jpegData, metadata: metadata)
            
            guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
                throw URLError(.badServerResponse)
            }
            print("Old Path: \(returnedPath)")
            return (returnedPath, returnedName)
        }
        return ("", "")
    }
    func uploadAvatarImageToFairbase(data: Data, userId: String) async throws -> (path: String, name: String) {
        
        if let image = UIImage(data: data) {
            guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 150, height: 150)),
                  let jpegData = resizeImage.jpegData(compressionQuality: 0.8) else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let path = "\(userId)_avatar.jpg"
            let returnedMetadata = try await userReferenceImage(userId: userId).child("portfolio").child(path).putDataAsync(jpegData, metadata: metadata)
            
            guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
                throw URLError(.badServerResponse)
            }
            return (returnedPath, returnedName)
        }
        return ("", "")

    }

    func uploadSampleImageDataToFirebase(data: Data, userId: String) async throws -> (path: String, name: String) {
        if let image = UIImage(data: data) {
            guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 800, height: 800)),
                  let jpegData = resizeImage.jpegData(compressionQuality: 0.8) else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let path = "\(UUID().uuidString).jpg"
            let returnedMetadata = try await userReferenceImage(userId: userId).child("sample").child(path).putDataAsync(jpegData, metadata: metadata)
            
            guard let returnedPath = returnedMetadata.path, let returnedName = returnedMetadata.name else {
                throw URLError(.badServerResponse)
            }
            return (returnedPath, returnedName)
        }
        return ("", "")
    }
    func uploadAvatarToFairbase(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        guard let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 240, height: 240)),
              let jpegData = resizeImage.jpegData(compressionQuality: 0.8) else {
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


