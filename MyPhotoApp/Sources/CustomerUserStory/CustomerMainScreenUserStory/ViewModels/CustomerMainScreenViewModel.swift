//
//  CustomerMainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/21/23.
//

import Foundation
import Combine

@MainActor
final class CustomerMainScreenViewModel: CustomerMainScreenViewModelType, ObservableObject {
    @Published var portfolio: [AuthorPortfolioModel]
    @Published var selectedItem: AuthorPortfolioModel? = nil
    @Published var showDetailScreen: Bool = false
    
    init() {
            self.portfolio = [] // Initialize with an empty array initially
            Task {
                do {
                    let bdPortfolio = try await getAllPortfolioInLocation(location: "Thailand")
                    self.portfolio = bdPortfolio.map { AuthorPortfolioModel(portfolio: $0) }
                    print(portfolio)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    
    func getAllPortfolioInLocation(location: String) async throws -> [DBPortfolioModel] {
        do {
            let portfolio = try await UserManager.shared.getAllPortfolio(location: location)
            return portfolio
        } catch {
            throw error
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
