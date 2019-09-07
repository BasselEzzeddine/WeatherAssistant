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
    func presentWeatherMessage(_ response: AssistantModel.Fetch.Response)
    func presentErrorMessage()
}

class AssistantInteractor {
    
    // MARK: - Properties
    var presenter: AssistantInteractorOut?
    var voiceListener: VoiceListener?
    var weatherWorker: WeatherWorker?
    
    // MARK: - Methods
    private func startListeningAndRecognizingWords() {
        self.voiceListener?.startListening(completionHandler: { [weak self]
            (recognizedWord: String) in
            //print(recognizedWord)
            if recognizedWord.lowercased() == "weather" {
                self?.weatherWorker?.fetchCurrentWeather(completionHandler: { [weak self]
                    (rawWeather: RawWeather?, success: Bool) in
                    DispatchQueue.main.async {
                        self?.handleFetchCurrentWeatherResponse(rawWeather: rawWeather, success: success)
                    }
                })
            }
        })
    }
    
    private func handleFetchCurrentWeatherResponse(rawWeather: RawWeather?, success: Bool) {
        if let rawWeather = rawWeather, success {
            let main = rawWeather.main
            let response = AssistantModel.Fetch.Response(temperature: main.temp, pressure: main.pressure, humidity: main.humidity)
            self.presenter?.presentWeatherMessage(response)
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
                self.startListeningAndRecognizingWords()
            }
            else {
                self.presenter?.presentErrorMessage()
            }
        })
    }
}
