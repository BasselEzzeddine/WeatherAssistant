//
//  AssistantConfigurator.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import Speech

extension AssistantViewController: AssistantPresenterOut {
}

extension AssistantInteractor: AssistantViewControllerOut {
}

extension AssistantPresenter: AssistantInteractorOut {
}

class AssistantConfigurator {
    
    // MARK: - Properties
    static let sharedInstance = AssistantConfigurator()
    
    // MARK: - Methods
    func configure(viewController: AssistantViewController) {
        let speaker = Speaker()
        speaker.synthesizer = AVSpeechSynthesizer()
        
        let presenter = AssistantPresenter()
        presenter.viewController = viewController
        presenter.speaker = speaker
        
        let voiceListener = VoiceListener()
        voiceListener.audioEngine = AVAudioEngine()
        voiceListener.speechRecognizer = SFSpeechRecognizer()
        voiceListener.speechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        voiceListener.recognitionTask = SFSpeechRecognitionTask()
        
        let weatherWorker = WeatherWorker()
        
        let interactor = AssistantInteractor()
        interactor.presenter = presenter
        interactor.voiceListener = voiceListener
        interactor.weatherWorker = weatherWorker
        
        viewController.interactor = interactor
    }
}
