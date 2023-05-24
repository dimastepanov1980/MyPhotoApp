//
//  DetailOrderViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import Foundation

protocol DetailOrderViewModelType: ObservableObject {
    var name: String  { get }
    var instagramLink: String? { get }
    var price: Int? { get }
    var place: String? { get }
    var description: String? { get }
    var duration: Double { get }
    var image: String? { get }
    var date: Date { get }
    var images: [ImageModel] { get }
    
    func addImage(_ image: String)
    func formattedDate() -> String 
}
