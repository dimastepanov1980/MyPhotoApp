//
//  CustomerDetailOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
protocol CustomerDetailOrderViewModelType: ObservableObject {
    var avaibleStatus: [String] { get set }
    var status: String { get set }
    var statusColor: Color { get }
    var referenceImages: [String : UIImage?] { get set }
    var smallReferenceImages: [String] { get }

    
    func formattedDate(date: Date, format: String) -> String
    func lacalizationStatus(orderStatus: String)
    func returnedStatus(status: String) -> String
    func sortedDate(array: [String]) -> [String]
    func currencySymbol(for regionCode: String) -> String
    
    func addReferenceImages(selectedImages: [PhotosPickerItem], orderId: String) async throws
    func deleteReferenceImages(pathKey: String, orderId: String) async throws
    func getReferenceImages(imagesPath: [String]) async throws
    func openInstagramProfile(username: String)

}
