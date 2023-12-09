//
//  CustomerDetailScreenViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/26/23.
//

import Foundation
import SwiftUI

@MainActor
protocol CustomerDetailScreenViewModelType: ObservableObject {
    var portfolio: AuthorPortfolioModel { get }
    var startScheduleDay: Date { get set }
    var selectedTime: [String] { get set }
    var timeslotSelectedDay: [String] { get set }
    var today: Date { get set }
    var priceForDay: String { get set }
    var appointments: [AppointmentModel] { get set }
    var minPrice: String { get set }
    var avatarImage: UIImage? { get set }
    
    func formattedDate(date: Date, format: String) -> String
    func stringToURL(imageString: String) -> URL?
    func currencySymbol(for regionCode: String) -> String
    func sortedDate(array: [String]) -> [String]
    func isTodayDay(date: Date) -> Bool
    func selectedDate(date: Date) -> Bool
    func getMinPrice(appointmen: [DbSchedule])
    func createAppointments(schedule: [DbSchedule], startMyTripDate: Date, bookingDays: [String : [String]])
    func getAvatarImage(imagePath: String) async throws

}
