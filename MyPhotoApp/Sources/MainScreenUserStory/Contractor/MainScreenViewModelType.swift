//
//  MainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

@MainActor
protocol MainScreenViewModelType: ObservableObject {
    var weather: WeatherModel? { get set }
    var orders: [UserOrdersModel] { get }
    var weatherByDate: [Date: [Weather?]] { get }
    var selectedDay: Date { get set }
    var today: Date { get set }
    
    func formattedDate(date: Date, format: String) -> String
    func isToday(date: Date) -> Bool
    func isTodayDay(date: Date) -> Bool
    func loadOrders() async throws
    func deleteOrder(order: UserOrdersModel) async throws
    func fetchCurrentWeather(lat: String, lon: String, exclude: String) async throws
}
