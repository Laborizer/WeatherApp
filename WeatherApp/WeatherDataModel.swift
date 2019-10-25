//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Lauri Laiho on 09/10/2019.
//  Copyright © 2019 Lauri Laiho. All rights reserved.
//

import Foundation

struct WeatherDataModel: Codable {
    var name: String
    var sys: Sys
    var weather: [Weather]
    var main: Main
}

struct Weather: Codable {
    var description: String
    var icon: String
    var main: String
}

struct Main: Codable {
    var temp: Double
}

struct Sys: Codable {
    var country: String
}

struct ForecastDataModel: Codable {
    var list: [List]
}

struct List: Codable {
    var dt_txt: String
    var main: Main
    var weather: [Weather]
}

struct City {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
