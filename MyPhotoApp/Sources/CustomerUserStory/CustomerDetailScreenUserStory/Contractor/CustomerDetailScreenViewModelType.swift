//
//  CustomerDetailScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/26/23.
//

import Foundation

@MainActor
protocol CustomerDetailScreenViewModelType: ObservableObject {
    var items: AuthorPortfolioModel { get set }

    func formattedDate(date: Date, format: String) -> String
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String

}
