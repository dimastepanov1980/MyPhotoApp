//
//  Router.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/20/23.
//

import Foundation
import SwiftUI

enum Views: Hashable {
    case CustomerPageHubView
    case AuthorHubPageView
    case CustomerDetailScreenView(with: AuthorPortfolioModel)
}

enum ViewFactory {
    
    @MainActor @ViewBuilder
    static func viewForDestination(_ destination: Views, showAuthenticationView: Binding<Bool>) -> some View {
        
        switch destination {
            
        case .CustomerPageHubView:
            CustomerPageHubView(showAuthenticationView: showAuthenticationView)
            
        case .AuthorHubPageView:
            AuthorHubPageView(showAuthenticationView: showAuthenticationView)
            
        case .CustomerDetailScreenView(let viewModel):
            CustomerDetailScreenView(with: CustomerDetailScreenViewModel(portfolio: viewModel, startScheduleDay: Date()))
        }
    }
}


final class Router<T: Hashable>: ObservableObject {
    @Published var paths: [T] = []
    
    func push(_ path: T) {
        paths.append(path)
    }
    
    func pop() {
           paths.removeLast(1)
       }
    
    func popToRoot() {
           paths.removeAll()
       }
    
    func pop(to: T) {
            guard let found = paths.firstIndex(where: { $0 == to }) else {
                return
            }
            let numToPop = (found..<paths.endIndex).count - 1
            paths.removeLast(numToPop)
        }
}
