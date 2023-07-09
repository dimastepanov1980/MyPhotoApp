//
//  DetailOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
protocol DetailOrderViewModelType: ObservableObject {
    var name: String  { get }
    var instagramLink: String? { get }
    var price: String? { get }
    var place: String? { get }
    var description: String? { get }
    var duration: String { get }
    var image: [String]? { get }
    var date: Date { get set }
//    var selectedItems: [PhotosPickerItem] { get }
//    var setImage: [Data] { get set }
//    var selectImages: [UIImage] { get set }
//    var order: UserOrdersModel { get set }

    
    func formattedDate(date: Date, format: String) -> String
    func addReferenceUIImages(selectedItems: [PhotosPickerItem]) async throws
    func fetchImages() async throws
}
