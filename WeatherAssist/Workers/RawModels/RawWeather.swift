//
//  RawWeather.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

struct RawWeather: Codable, Equatable {
    let main: Main
    
    struct Main: Codable, Equatable {
        let temp: Float
        let pressure: Float
        let humidity: Float
    }
}

func ==(lhs: RawWeather, rhs: RawWeather) -> Bool {
    return lhs.main == rhs.main
}

func ==(lhs: RawWeather.Main, rhs: RawWeather.Main) -> Bool {
    return lhs.temp == rhs.temp
        && lhs.pressure == rhs.pressure
        && lhs.humidity == rhs.humidity
}
