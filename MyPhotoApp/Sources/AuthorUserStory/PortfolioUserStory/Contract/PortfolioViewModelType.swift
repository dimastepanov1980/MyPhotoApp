//
//  PortfolioViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/31/23.
//

import Foundation

protocol PortfolioViewModelType: ObservableObject {
    
    var items: AuthorPortfolioModel { get }
   
    
    var authorName: String { get }
    var authorRegion: String { get }
    var authorCity: String { get }

    
    
    func formattedDate(date: Date, format: String) -> String
    func sortedDate(array: [String]) -> [String]
    
}
