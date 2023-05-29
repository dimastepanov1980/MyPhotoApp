//
//  DetailOrderViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation

@MainActor
final class DetailOrderViewModel: DetailOrderViewModelType {
    var name = ""
    var instagramLink: String?
    var price: Int?
    var place: String?
    var description: String?
    var duration = 0.0
    var image: String?
    var date: Date = Date()
    var images: [ImageModel] = []
    
    private let order: MainOrderModel

    init(order: MainOrderModel) {
        self.order = order
        updatePreview()
    }
    
    func updatePreview() {
        name = order.name
        instagramLink = order.instagramLink
        price = order.price
        place = order.place
        description = order.description
        duration = order.duration
        
    }
    func addImage(_ image: String) {
        //
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM" // Set the desired output date format
        return dateFormatter.string(from: date)
    }
}
