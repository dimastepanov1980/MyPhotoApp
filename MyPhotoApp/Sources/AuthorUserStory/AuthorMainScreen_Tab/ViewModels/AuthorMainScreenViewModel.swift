//
//  AuthorMainScreenViewModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import Foundation
import Combine
import SwiftUI
import FirebaseFirestore
import MapKit

@MainActor
final class AuthorMainScreenViewModel: AuthorMainScreenViewModelType, ObservableObject {
    
    var location = LocationService()
    private var cancellables = Set<AnyCancellable>()
    private var listenerRegistration: [ListenerRegistration]?
    @Published private var user: DBUserModel?

    @Published var filteredOtherOrders: [Date : [OrderModel]] = [:]
    @Published var filteredUpcomingOrders: [Date : [OrderModel]] = [:]
    @Published var filteredOrdersForToday: [OrderModel] = []
    
    @Binding var userProfileIsSet: Bool
    @Binding var userPortfolioIsSet: Bool
    @Published var weatherByDate: [Date: [Weather?]] = [:]
    @Published var weatherForCurrentDay: String? = nil
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    @Published var modified = false
    
    init(userProfileIsSet: Binding<Bool>,
         userPortfolioIsSet: Binding<Bool>) {
        self._userProfileIsSet = userProfileIsSet
        self._userPortfolioIsSet = userPortfolioIsSet
        print("location: \(location)")
        location.$location
                  .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
                  .sink { [weak self] newLocation in
                      // Update the view with the new location value
                      self?.handleNewLocation(newLocation)
                  }
                  .store(in: &cancellables)
        
        Task {
         await subscribe()
        }
    }
    func fetchWeather(with location: CLLocation) {
        let longitude = location.coordinate.longitude.description
        let latitude = location.coordinate.latitude.description
        print("fetchWeather: \(longitude), \(latitude)")
        let today = Date()
        let calendar = Calendar.current
        var weatherByDate: [Date: [Weather?]] = [:]
        Task {
            do {
                let weather = try await WeatherManager.shared.fetcWeather(lat: latitude, lon: longitude, exclude: "minutely,hourly,alerts")
                let weatherForAllDay = weather.daily
                let weatherForCurrentDay = weather.current.weather.first?.icon
                print("weatherForCurrentDay: \(String(describing: weatherForCurrentDay))")

                (0...14).forEach { day in
                    let dayOfWeek = calendar.date(byAdding: .day, value: day, to: today)!
                    let matchingDate = weatherForAllDay.first { formattedDate(date: dayOfWeek, format: "dd MMMM YYYY") == formattedDate(date: $0.dt, format: "dd MMMM YYYY") }
                    
                    if let matchingDate = matchingDate {
                        weatherByDate[dayOfWeek] = matchingDate.weather
                    } else {
                        weatherByDate[dayOfWeek] = [nil]
                    }
                }
                
                DispatchQueue.main.async {
                    self.weatherForCurrentDay = weatherForCurrentDay
                    self.weatherByDate = weatherByDate

                }
                
            } catch {
                print("Error fetching weather: \(error.localizedDescription)")
                // Handle the error, show an error message.
            }
        }

    }
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDay, inSameDayAs: date)
    }
    func isTodayDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(today, inSameDayAs: date)
    }

    func subscribe() async {
        var filteredOtherOrders: [Date: [OrderModel]] = [:]
        var filteredUpcomingOrders: [Date: [OrderModel]] = [:]
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        guard let authDateResult = try? AuthNetworkService.shared.getAuthenticationUser() else {
            return
        }
        listenerRegistration = UserManager.shared.subscribeToAllAuthorOrders(userId: authDateResult.uid) { recivingOrders in
            var ordersForToday: [OrderModel] = []
            for order in recivingOrders {
                let date = Calendar.current.startOfDay(for: order.orderShootingDate)
                if date < currentDate {
                    if filteredOtherOrders[date] == nil {
                        filteredOtherOrders[date] = [OrderModel(order: order)]
                    } else {
                        filteredOtherOrders[date]?.append(contentsOf: [OrderModel(order: order)])
                    }
                } else if date > currentDate {
                    if filteredUpcomingOrders[date] == nil {
                        filteredUpcomingOrders[date] = [OrderModel(order: order)]
                    } else {
                        filteredUpcomingOrders[date, default: []].append(contentsOf: [OrderModel(order: order)])
                    }
                } else if date == currentDate {
                    if ordersForToday.isEmpty {
                        ordersForToday = [OrderModel(order: order)]
                    } else {
                        ordersForToday.append(contentsOf: [OrderModel(order: order)])
                    }
                }
            }
            
            self.filteredOrdersForToday = ordersForToday
            ordersForToday = []
            self.filteredOtherOrders = filteredOtherOrders
            filteredOtherOrders = [:]
            self.filteredUpcomingOrders = filteredUpcomingOrders
            filteredUpcomingOrders = [:]
        }
    }


    func orderStausColor (order: String?) -> Color {
        if let order = order {
            switch order {
            case "Upcoming":
                return Color(R.color.upcoming.name)
            case "In progress":
                return Color(R.color.inProgress.name)
            case "Completed":
                return Color(R.color.completed.name)
            case "Canceled":
                return Color(R.color.canceled.name)
            default:
                break
            }
        }
        return Color.gray
    }
    func orderStausName (status: String?) -> String {
        if let order = status {
            switch order {
            case "Upcoming":
                return R.string.localizable.status_upcoming()
            case "In progress":
                return R.string.localizable.status_inProgress()
            case "Completed":
                return R.string.localizable.status_completed()
            case "Canceled":
                return R.string.localizable.status_canceled()
            default:
                break
            }
        }
        return R.string.localizable.status_upcoming()
    }
    func getIconForWeatherCode(weatherCode: String) -> String {
        switch weatherCode {
        case "01d", "01n":
            return "sun.max"
        case "02d", "02n":
            return "cloud.sun"
        case "03d", "03n":
            return "cloud"
        case "04d", "04n":
            return "cloud"
        case "09d", "09n":
            return "cloud.rain"
        case "10d", "10n":
            return "cloud.sun.rain"
        case "11d", "11n":
            return "cloud.bolt.rain"
        case "13d", "13n":
            return "cloud.snow"
        case "50d", "50n":
            return "cloud.fog"
        default:
            return "icloud.slash"
        }
    }
    
    func getMinimalTimeSlot(_ time: String) -> Int {
        let components = time.split(separator: ":")
        if components.count == 2, let hours = Int(components[0]), let minutes = Int(components[1]) {
            return hours * 60 + minutes
        }
        return 0
    }
    
    private func handleNewLocation(_ location: CLLocation?) {
        guard let location = location else {
            print("Location is nil.")
            return
        }
        print("location: \(location)")
        fetchWeather(with: location)
    }
}

enum StatusOrder {
    case Upcoming
    case InProgress
    case Done
    case Cancelled
}
