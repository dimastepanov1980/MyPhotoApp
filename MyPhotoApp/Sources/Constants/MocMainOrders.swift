//
//  MocMainOrders.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/24/23.
//

import Foundation

class MocMainOrders: DetailOrderViewModelType {
    var name: String = "Ira"
    
    var instagramLink: String? = nil
    
    var price: Int? = 6500
    
    var place: String? = "Kata Noy Beach1"
    
    var description: String? = "Included with your membership are two Technical Support Incidents (TSIs), which can be used during your membership year to request code-level support for Apple frameworks, APIs, and tools from an Apple Developer Technical Support Engineer. You’ll receive two new TSIs when you renew your membership. Additional TSIs are available for purchase at any time."
    
    var duration: Double = 1.5
    
    var image: String? = nil
    
    var date: Date = Date()
    
    var images: [ImageModel] = []
    
    func addImage(_ image: String) {
        //
    }
    
    func formattedDate() -> String {
        return ""
    }
    
    let orders: [MainOrderModel] = [
        MainOrderModel(id: UUID(),
                       name: "Ira",
                       instagramLink: nil,
                       place: "Kata Noy Beach",
                       price: 5500,
                       date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                       duration: 1.5,
                       description: nil,
                       imageUrl: ""),
        MainOrderModel(id: UUID(),
                       name: "Ira",
                       instagramLink: nil,
                       place: "Kata Noy Beach",
                       price: 5500,
                       date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date(),
                       duration: 1.5,
                       description: nil,
                       imageUrl: ""),
        MainOrderModel(id: UUID(),
                       name: "Ira",
                       instagramLink: nil,
                       place: "Kata Noy Beach",
                       price: 5500,
                       date: Calendar.current.date(byAdding: .day, value: +3, to: Date()) ?? Date(),
                       duration: 1.5,
                       description: nil,
                       imageUrl: ""),
    ]
}
