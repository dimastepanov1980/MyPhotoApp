//
//  MainScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation

protocol MainScreenViewModelType: ObservableObject {
    var userId: String { get }
    var name: String { get }
    var place: String? { get }
    var dateOrder: Date { get }
    var duration: Double { get }
    var imageUrl: String { get }
    var weaterId: String { get }
    var orders: [MainOrderModel] { get }
    var currentWeek: [Date] { get }
    var currentDay: Date { get set }
    var today: Date { get }
    
    func createOrder()
    func formattedDate(date: Date) -> String
    func fetchCurrentWeek()
    func extractDate(date: Date, format: String) -> String
    func isToday(date: Date) -> Bool
    func isTodayDay(date: Date) -> Bool
}