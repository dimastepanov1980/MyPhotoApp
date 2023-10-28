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
    var customer: DBUserModel? { get }
    var selectedDay: Date? { get set }
    var selectedTime: [String] { get set }
    var timeslotSelectedDay: [TimeSlotModel] { get set }
    var today: Date { get set }
    var priceForDay: String { get set }
    var appointments: [AppointmentModel] { get set }
    var minPrice: String { get set }
    
    func formattedDate(date: Date, format: String) -> String
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String
    func sortedDate(array: [String]) -> [String]
    func isTodayDay(date: Date) -> Bool
    func isToday(date: Date) -> Bool
    func createAppointments(schedule: [DbSchedule], startMyTripDate: Date)

}
