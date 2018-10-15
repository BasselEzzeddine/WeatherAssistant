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
