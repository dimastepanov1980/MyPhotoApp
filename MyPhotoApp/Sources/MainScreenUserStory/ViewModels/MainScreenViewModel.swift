//
//  MainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

final class MainScreenViewModel: MainScreenViewModelType {
    @Published var userId: String = ""
    @Published var name: String  = ""
    @Published var place: String?
    @Published var date: Date  = Date()
    @Published var duration: Double = 0.0
    @Published var imageUrl: String = ""
    @Published var weaterId: String  = ""
    
    func createOrder() {
        //
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM" // Set the desired output date format
        return dateFormatter.string(from: date)
    }
    
}
