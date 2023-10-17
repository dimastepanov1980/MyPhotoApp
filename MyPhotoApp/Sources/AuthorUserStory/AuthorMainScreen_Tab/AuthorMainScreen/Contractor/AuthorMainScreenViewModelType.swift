//
//  AuthorMainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation
import SwiftUI
import Combine
import MapKit

@MainActor
protocol AuthorMainScreenViewModelType: ObservableObject {
    var orders: [DbOrderModel] { get }
    var weatherByDate: [Date: [Weather?]] { get }
    var selectedDay: Date { get set }
    var today: Date { get set }
    var weatherForCurrentDay: String? { get }
    var filteredUpcomingOrders: [Date : [DbOrderModel]] { get }
    var filteredOtherOrders: [Date : [DbOrderModel]] { get }
    var filteredOrdersForToday: [DbOrderModel] { get }
    var location: LocationService { get set }
    
    func formattedDate(date: Date, format: String) -> String
    func isToday(date: Date) -> Bool
    func isTodayDay(date: Date) -> Bool
    func deleteOrder(order: DbOrderModel) async throws
    func fetchWeather(with location: CLLocation)
    func orderStausColor (order: String?) -> Color
    func orderStausName (status: String?) -> String
    func getIconForWeatherCode(weatherCode: String) -> String
}
