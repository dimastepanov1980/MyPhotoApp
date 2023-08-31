//
//  CustomerDetailScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/26/23.
//

import Foundation

@MainActor
protocol CustomerDetailScreenViewModelType: ObservableObject {
    var items: AuthorPortfolioModel { get set }
    var selectedDay: Date? { get set }
    var selectedTime: [String] { get set }
    var timeslotSelectedDay: [DBTimeSlot] { get set }
    var today: Date { get set }
    func formattedDate(date: Date, format: String) -> String
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String
    func sortedDate(array: [String]) -> [String]
    func isTodayDay(date: Date) -> Bool
    func isToday(date: Date) -> Bool 

}
