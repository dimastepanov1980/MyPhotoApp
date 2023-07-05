//
//  WeatherManager.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/26/23.
//

import Foundation

@MainActor
final class WeatherManager {
    
    static let shared = WeatherManager()
    
    func fetcWeather(lat: String, lon: String, exclude: String) async throws -> WeatherModel {
        let urlConstant = "https://api.openweathermap.org/data/3.0/onecall?lat="
        let apiKey = "1bf41410bf603891cf92ed40d5fcf859"
        guard let url = URL(string: "\(urlConstant)\(lat)&lon=\(lon)&exclude=\(exclude)&appid=\(apiKey)") else {
            throw Constants.CustomError.invalidURL
        }        
        let(data, response) = try await URLSession.shared.data(from: url)
        guard let response  = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Constants.CustomError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let weatherModel = try decoder.decode(WeatherModel.self, from: data)
            print(weatherModel)
            return weatherModel
        } catch {
            throw error
        }
    }
}
