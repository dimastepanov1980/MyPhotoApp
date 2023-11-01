//
//  PortfolioDetailScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import Foundation

@MainActor

final class PortfolioDetailScreenViewModel: PortfolioDetailScreenViewModelType {
    @Published var images: [String]
    
    init(images: [String]){
        self.images = images
    }
    
}
