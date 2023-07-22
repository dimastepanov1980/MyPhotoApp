//
//  MainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

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
    
    func formattedDate(date: Date, format: String) -> String
    func isToday(date: Date) -> Bool
    func isTodayDay(date: Date) -> Bool
    func deleteOrder(order: UserOrdersModel) async throws
    func fetchWeather(lat: String, lon: String, exclude: String) async throws
}
