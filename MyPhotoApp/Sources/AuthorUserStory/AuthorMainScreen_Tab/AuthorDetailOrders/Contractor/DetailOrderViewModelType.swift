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
    var selectedItems: [PhotosPickerItem] { get }
    var setImage: [Data] { get set }
    var selectImages: [UIImage] { get set }
    var order: DbOrderModel { get set }
    var avaibleStatus: [String] { get set }
    var status: String { get set }
    var statusColor: Color { get }
    var imageURLs: [URL] { get }
    
    func formattedDate(date: Date, format: String) -> String
    func addReferenceUIImages(selectedItems: [PhotosPickerItem]) async throws
//    func fetchImageURL(imageUrlArray: [String]) async throws
    func updateStatus(orderModel: DbOrderModel) async throws
    func removeURLSelectedImage(order: DbOrderModel, path: URL, imagesArray: [String]) async throws
    func returnedStatus(status: String) -> String

}
