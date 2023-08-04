//
//  MainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation
import SwiftUI
import Combine
import MapKit

@MainActor
protocol MainScreenViewModelType: ObservableObject {
    var orders: [UserOrdersModel] { get }
    var weatherByDate: [Date: [Weather?]] { get }
    var selectedDay: Date { get set }
    var today: Date { get set }
    var weatherForCurrentDay: String? { get }
    var filteredUpcomingOrders: [Date : [UserOrdersModel]] { get }
    var filteredOtherOrders: [Date : [UserOrdersModel]] { get }
    var filteredOrdersForToday: [UserOrdersModel] { get }
    var location: LocationViewModel { get set }
    var objectWillChange: ObservableObjectPublisher { get }

    
    func formattedDate(date: Date, format: String) -> String
    func isToday(date: Date) -> Bool
    func isTodayDay(date: Date) -> Bool
    func deleteOrder(order: UserOrdersModel) async throws
    func fetchWeather(with location: CLLocation)
    func orderStausColor (order: String?) -> Color
    func orderStausName (status: String?) -> String
    func getIconForWeatherCode(weatherCode: String) -> String
}
