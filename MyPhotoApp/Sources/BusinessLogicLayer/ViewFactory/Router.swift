//
//  Router.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/20/23.
//

import Foundation
import SwiftUI

enum Views: Hashable {
    case RootScreenView
    case CustomerPageHubView
    case AuthorHubPageView
    case CustomerDetailScreenView(viewModel: AuthorPortfolioModel, date: Date)
    case PortfolioDetailScreenView(images: [String])
    case ImageDetailView(image: String)
    case CustomerConfirmOrderView(authorId: String, authorName: String, authorSecondName: String, location: String, regionAuthor : String, authorBookingDays: [String : [String]], orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String)
    case CustomerStatusOrderScreenView(title: String,
                                       message: String,
                                       buttonTitle: String)
    case DetailOrderView(order: DbOrderModel)
    case AuthorAddOrderView(order: DbOrderModel?, mode: Constants.OrderMode)
    case SignInSignUpView(authType: authType)
    case ReAuthenticationView
    case ProfileScreenView
    case PortfolioView
    case PortfolioEditView(viewModel: AuthorPortfolioModel?, image: UIImage?)
    case PortfolioScheduleView
    case InformationScreenView
    case EmptyView

}

enum ViewFactory {
    
    @MainActor @ViewBuilder
    static func viewForDestination(_ destination: Views) -> some View {
        
        switch destination {
            
// MARK: - Both Zone
        case .RootScreenView:
            RootScreenView()
            
        case .SignInSignUpView(let authType):
            SignInSignUpView(with: SignInSignUpViewModel(), authType: authType)
            
        case .ReAuthenticationView:
            ReAuthenticationView(with: ReAuthenticationViewModel())
            
        case .ProfileScreenView:
            ProfileScreenView(with: ProfileScreenViewModel())
        case .InformationScreenView:
            InformationScreenView()

// MARK: Customer Zone-
        case .CustomerPageHubView:
            CustomerPageHubView()
        case .PortfolioDetailScreenView(let images):
            PortfolioDetailScreenView(images: images)
        case .CustomerDetailScreenView(let viewModel, let date):
            CustomerDetailScreenView(with: CustomerDetailScreenViewModel(portfolio: viewModel, startScheduleDay: date))
        case .CustomerConfirmOrderView(let authorId, let authorName, let authorSecondName, let authorLocation, let regionAuthor, let authorBookingDays, let orderDate, let orderTime, let orderDuration, let orderPrice):
            CustomerConfirmOrderView(with: CustomerConfirmOrderViewModel(authorId: authorId, authorName: authorName, authorSecondName: authorSecondName, location: authorLocation, regionAuthor: regionAuthor, authorBookingDays: authorBookingDays, orderDate: orderDate, orderTime: orderTime, orderDuration: orderDuration, orderPrice: orderPrice))
        case .CustomerStatusOrderScreenView(let title, let message,let buttonTitle):
            CustomerStatusOrderScreenView(title: title, message: message, buttonTitle: buttonTitle)
            
        case .DetailOrderView(let order):
            DetailOrderView(with: DetailOrderViewModel(order: order))
        case .ImageDetailView(let image):
            ImageDetailView(imagePath: image)

// MARK: Author Zone -
        case .AuthorAddOrderView(let order, let mode):
            AuthorAddOrderView(with: AuthorAddOrderViewModel(order: order), mode: mode)
                .onAppear { UIDatePicker.appearance().minuteInterval = 30 }
        case .AuthorHubPageView:
            AuthorHubPageView()
        case .PortfolioView:
            PortfolioView(with: PortfolioViewModel())
        case .PortfolioEditView(let viewModel, let image):
            PortfolioEditView(with: PortfolioEditViewModel(portfolio: viewModel, avatarImage: image))
        case .PortfolioScheduleView:
            PortfolioScheduleView(with: PortfolioScheduleViewModel())
                .onAppear { UIDatePicker.appearance().minuteInterval = 30 }
        case .EmptyView:
            VStack{
                Text("Hello")
            }
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
    
    func popTo(number: Int) {
           paths.removeLast(number)
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
