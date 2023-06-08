//
//  MainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

@MainActor
protocol MainScreenViewModelType: ObservableObject {
    var weaterId: String { get }
    var orders: [UserOrdersModel] { get }
    var currentWeek: [Date] { get }
    var currentDay: Date { get set }
    var today: Date { get set }
    
    func formattedDate(date: Date) -> String
    func fetchCurrentWeek()
    func extractDate(date: Date, format: String) -> String
    func isToday(date: Date) -> Bool
    func isTodayDay(date: Date) -> Bool
    func loadOrders() async throws
    func deleteOrder(order: UserOrdersModel) async throws
}
