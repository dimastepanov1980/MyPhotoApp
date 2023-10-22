//
//  WeatherModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/25/23.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let lat: Double
    let lon: Double
    let current: Current
    let daily: [Daily]

}
// MARK: - Daily
struct Daily: Codable {
    let dt: Date
    let temp: Temp
    let weather: [Weather]
}
// MARK: - Current
struct Current: Codable {
    let dt: Date
    let temp: Double
    let weather: [Weather]
}
// MARK: - Temp
struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
// MARK: - Weather
struct Weather: Codable, Hashable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
