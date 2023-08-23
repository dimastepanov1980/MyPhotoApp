//
//  CustomerMainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/21/23.
//

import Foundation

@MainActor
final class CustomerMainScreenViewModel: CustomerMainScreenViewModelType, ObservableObject {
   @Published var portfolio: [AuthorPortfolioModel]
    
    init(portfolio: [AuthorPortfolioModel] = []) {
        self.portfolio = portfolio
    }
    
    func getAllPortfolioInLocation(location: String) async throws {
        do {
            let portfolio = try await UserManager.shared.getAllPortfolio(location: location)
            print(portfolio)
        } catch {
            print(error.localizedDescription)
        }
    }
    func stringToURL(imageString: String) -> URL? {
        guard let imageURL = URL(string: imageString) else { return nil }
        return imageURL
    }
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
}
