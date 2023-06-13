//
//  MocMainOrders.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/24/23.
//

import Foundation
import SwiftUI
import PhotosUI

class MocMainOrders: DetailOrderViewModelType {
    func getReferenceImages(path: String) async throws {
        //
    }
    
    func addAvatarImage(image: PhotosPickerItem) {
        //
    }

    func addReferenceImages(images: [PhotosPickerItem]) {
        //
    }
    
    var name: String = "Ira"
    
    var instagramLink: String? = nil
    
    var price: Int? = 6500
    
    var place: String? = "Kata Noy Beach1"
    
    var description: String? = "Included with your membership are two Technical Support Incidents (TSIs), which can be used during your membership year to request code-level support for Apple frameworks, APIs, and tools from an Apple Developer Technical Support Engineer. You’ll receive two new TSIs when you renew your membership. Additional TSIs are available for purchase at any time."
    
    var duration: String = "1.5"
    
    var image: [String]? = nil
    
    var date: Date = Date()
    
    var images: [ImageModel] = []
    
    
    func formattedDate() -> String {
        return ""
    }

}
