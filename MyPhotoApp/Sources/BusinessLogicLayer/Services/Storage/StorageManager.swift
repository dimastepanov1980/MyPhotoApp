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
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return try await uploadImageToFairbase(data: data, userId: userId, orderId: orderId)

    }
}
