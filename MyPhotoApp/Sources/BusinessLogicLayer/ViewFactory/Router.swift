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
    case CustomerDetailScreenView(viewModel: AuthorPortfolioModel)
    case PortfolioDetailScreenView(images: [String])
    case CustomerConfirmOrderView(authorId: String, authorName: String, authorSecondName: String, location: String, regionAuthor : String, authorBookingDays: [String : [String]], orderDate: Date, orderTime: [String], orderDuration: String, orderPrice: String)
    case DetailOrderView(order: DbOrderModel)
    case AuthorAddOrderView(order: DbOrderModel, mode: Constants.OrderMode)
    case AuthenticationCustomerView
    case ProfileScreenView
//    case PortfolioEditView(locationAuthor: String, typeAuthor: String, nameAuthor: String, familynameAuthor: String, sexAuthor: String, ageAuthor: String, styleAuthor: String, avatarAuthor: String, avatarImage: UIImage?, descriptionAuthor: String, longitude: Double, latitude: String, regionAuthor: String)
    case InformationScreenView
    case EmptyView

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
            
        case .PortfolioDetailScreenView(let images):
            PortfolioDetailScreenView(images: images)
            
        case .CustomerConfirmOrderView(let authorId, let authorName, let authorSecondName, let authorLocation, let regionAuthor, let authorBookingDays, let orderDate, let orderTime, let orderDuration, let orderPrice):
            CustomerConfirmOrderView(with: CustomerConfirmOrderViewModel(authorId: authorId, authorName: authorName, authorSecondName: authorSecondName, location: authorLocation, regionAuthor: regionAuthor, authorBookingDays: authorBookingDays, orderDate: orderDate, orderTime: orderTime, orderDuration: orderDuration, orderPrice: orderPrice))
            
        case .DetailOrderView(let order):
            DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: .constant(false))
            
        case .AuthorAddOrderView(let order, let mode):
            AuthorAddOrderView(with: AuthorAddOrderViewModel(order: order), mode: mode)
            
            
        case .AuthenticationCustomerView:
            AuthenticationCustomerView(with: AuthenticationCustomerViewModel())
            
//        case .PortfolioEditView(let locationAuthor, let typeAuthor, let nameAuthor, let familynameAuthor, let sexAuthor, let ageAuthor, let  styleAuthor, let avatarAuthor,let  avatarImage, let descriptionAuthor, let longitude, let latitude, let regionAuthor):
//            PortfolioEditView(with: PortfolioEditViewModel(locationAuthor: locationAuthor, typeAuthor: typeAuthor, nameAuthor: nameAuthor, familynameAuthor: familynameAuthor, sexAuthor: sexAuthor, ageAuthor: ageAuthor, styleAuthor: styleAuthor, avatarAuthor: avatarAuthor, avatarImage: avatarImage, descriptionAuthor: descriptionAuthor, longitude: longitude, latitude: latitude, regionAuthor: regionAuthor))
            
        case .ProfileScreenView:
            ProfileScreenView(with: ProfileScreenViewModel(profileIsShow: .constant(true)), showAuthenticationView: showAuthenticationView)
            
        case .InformationScreenView:
            InformationScreenView()
            
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
