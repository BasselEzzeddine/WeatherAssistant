//
//  WeatherWorker.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class WeatherWorker {
    
    // MARK: - Methods
    func fetchCurrentWeather(completionHandler: @escaping(_ rawWeather: RawWeather?, _ success: Bool) -> Void) {
        let urlString = "\(API_ENDPOINT)/data/2.5/weather?q=berlin&type=accurate&units=metric&appid=e1cdd7738b9db747857959666b599c83"
        guard let url = URL(string: urlString) else {
            completionHandler(nil, false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let data = data, error == nil {
                do {
                    let decoder = JSONDecoder()
                    let rawWeather = try decoder.decode(RawWeather.self, from: data)
                    completionHandler(rawWeather, true)
                }
                catch {
                    completionHandler(nil, false)
                }
            }
            else {
                completionHandler(nil, false)
            }
        }).resume()
    }
}
