//
//  AssistantInteractor.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol AssistantInteractorIn {
    func executeTasksWaitingViewToLoad()
}

protocol AssistantInteractorOut {
    func presentWelcomeMessage()
    func presentWeatherMessage(response: AssistantModel.Response)
    func presentErrorMessage()
}

class AssistantInteractor {
    
    // MARK: - Properties
    var presenter: AssistantInteractorOut?
    var voiceListener: VoiceListener?
    var weatherWorker: WeatherWorker?
    
    // MARK: - Methods
    func startListeningToUserAndRecognizingWords() {
        self.voiceListener?.startListening(completionHandler: {
            (recognizedWord: String) in
            //print(recognizedWord)
            if recognizedWord.lowercased() == "weather" {
                self.weatherWorker?.fetchCurrentWeather(completionHandler: {
                    (rawWeather: RawWeather?, success: Bool) in
                    self.interpretFetchCurrentWeatherResponse(rawWeather: rawWeather, success: success)
                })
            }
        })
    }
    
    private func interpretFetchCurrentWeatherResponse(rawWeather: RawWeather?, success: Bool) {
        if let rawWeather = rawWeather, success {
            let main = rawWeather.main
            let response = AssistantModel.Response(temperature: Int(main.temp), pressure: Int(main.pressure), humidity: Int(main.humidity))
            self.presenter?.presentWeatherMessage(response: response)
        }
        else {
            self.presenter?.presentErrorMessage()
        }
    }
}

// MARK: - AssistantInteractorIn
extension AssistantInteractor: AssistantInteractorIn {
    func executeTasksWaitingViewToLoad() {
        presenter?.presentWelcomeMessage()
        voiceListener?.setupVoiceListening(completionHandler: {
            (isSuccessful: Bool) in
            if isSuccessful {
                self.startListeningToUserAndRecognizingWords()
            }
            else {
                self.presenter?.presentErrorMessage()
            }
        })
    }
}
