//
//  Configuration.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

#if TESTING
let API_ENDPOINT = "http://localhost:8080"

#elseif PRODUCTION
let API_ENDPOINT = "http://api.openweathermap.org"
#endif
