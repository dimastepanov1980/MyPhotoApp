//
//  PortfolioDetailScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import Foundation

@MainActor
protocol PortfolioDetailScreenViewModelType: ObservableObject {
    var images: [String] { get set }

    
}
