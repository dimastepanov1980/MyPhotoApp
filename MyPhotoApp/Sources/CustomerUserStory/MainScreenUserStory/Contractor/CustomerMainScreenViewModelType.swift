//
//  CustomerMainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/18/23.
//

import Foundation
import SwiftUI

@MainActor
protocol CustomerMainScreenViewModelType: ObservableObject {
    var portfolio: [AuthorPortfolioModel] { get }
    
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String
}


