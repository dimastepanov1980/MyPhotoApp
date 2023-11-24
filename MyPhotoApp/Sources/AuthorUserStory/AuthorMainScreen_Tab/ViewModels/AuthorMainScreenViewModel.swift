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
    private var listenerRegistration: ListenerRegistration?
    @Published private var user: DBUserModel?
    var filteredOtherOrders: [Date : [DbOrderModel]]  {
        var filteredOrders = [Date : [DbOrderModel]]()
        
        let currentDate = Calendar.current.startOfDay(for: Date()) // Get the current date without time
        
        for order in orders {
            let date = Calendar.current.startOfDay(for: order.orderShootingDate) // Get the order date without time
            
            if date < currentDate {
                let orderDate = Calendar.current.startOfDay(for: date)
                if filteredOrders[orderDate] == nil {
                    filteredOrders[orderDate] = [order]
                } else {
                    filteredOrders[orderDate]?.append(order)
                }
            }
        }
        return filteredOrders
    }
    var filteredUpcomingOrders: [Date : [DbOrderModel]] {
        var filteredOrders = [Date : [DbOrderModel]]()
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        for order in orders {
            let date = Calendar.current.startOfDay(for: order.orderShootingDate)
            
            if date > currentDate {
                let orderDate = Calendar.current.startOfDay(for: date)
                if filteredOrders[orderDate] == nil {
                    filteredOrders[orderDate] = [order]
                } else {
                    filteredOrders[orderDate]?.append(order)
                }
            }
        }
        return filteredOrders
    }
    var filteredOrdersForToday: [DbOrderModel] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        return orders.filter { order in
            let formattedOrderDate = dateFormatter.string(from: order.orderShootingDate)
            let formattedToday = dateFormatter.string(from: today)
            return formattedOrderDate == formattedToday
        }
    }
    
    @Binding var userProfileIsSet: Bool
    @Binding var userPortfolioIsSet: Bool
    
    @Published var orders: [DbOrderModel]
    @Published var weatherByDate: [Date: [Weather?]] = [:]
    @Published var weatherForCurrentDay: String? = nil
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    @Published var modified = false
    
    init(orders: [DbOrderModel] = [],
         userProfileIsSet: Binding<Bool>,
         userPortfolioIsSet: Binding<Bool>) {
        self.orders = orders
        self._userProfileIsSet = userProfileIsSet
        self._userPortfolioIsSet = userPortfolioIsSet
        
        location.$location
                  .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
                  .sink { [weak self] newLocation in
                      // Update the view with the new location value
                      self?.handleNewLocation(newLocation)
                  }
                  .store(in: &cancellables)
        
        Task {
            try await subscribe()
            try await checkProfileAndPortfolio()
            try await fetchLocation()
        }
    }
    
    func fetchLocation() async throws {
        try await location.requestLocation()
    }
    func fetchWeather(with location: CLLocation) {
        let longitude = location.coordinate.longitude.description
        let latitude = location.coordinate.latitude.description
        print(longitude, latitude)
        let today = Date()
        let calendar = Calendar.current
        var weatherByDate: [Date: [Weather?]] = [:]
        Task {
            do {
                let weather = try await WeatherManager.shared.fetcWeather(lat: latitude, lon: longitude, exclude: "minutely,hourly,alerts")
                let weatherForAllDay = weather.daily
                let weatherForCurrentDay = weather.current.weather.first?.icon
                
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
    func subscribe() async throws {
        let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        self.user = try await UserManager.shared.getUser(userId: authDateResult.uid)
       
        print("subscribe to Author: \(authDateResult)")
        listenerRegistration = UserManager.shared.subscribeAuthorOrders(userId: authDateResult.uid, completion: { orders in
            self.orders = orders
        })
        print("get orders from subscribe to Author \(authDateResult): \(orders)")
    }
    func checkProfileAndPortfolio() async throws {
        
        if user?.avatarUser?.isEmpty ?? true {
            self.userProfileIsSet = true
            print("Set up your avatarUser")
        }

        if user?.firstName?.isEmpty ?? true {
            self.userProfileIsSet = true
            print("Set up your firstName")
        }

        if user?.secondName?.isEmpty ?? true {
            self.userProfileIsSet = true
            print("Set up your secondName")
        }

        if (user?.phone?.isEmpty ?? true) {
            self.userProfileIsSet = true
            print("Set up your contacts - Phone")
        }
        if (user?.instagramLink?.isEmpty ?? true) {
            self.userProfileIsSet = true
            print("Set up your contacts - instagram Link")
        }

        if user?.setPortfolio == false {
            self.userPortfolioIsSet = true
            print("Set up your portfolio")
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
    
    private func handleNewLocation(_ location: CLLocation?) {
        guard let location = location else {
            print("Location is nil.")
            return
        }
        fetchWeather(with: location)
    }

}

enum StatusOrder {
    case Upcoming
    case InProgress
    case Done
    case Cancelled
}
