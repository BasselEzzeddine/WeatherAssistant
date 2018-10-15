//
//  Speaker.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import Speech

class Speaker: NSObject {
    
    // MARK: - Properties
    var synthesizer: AVSpeechSynthesizer?
    
    // MARK: - NSObject
    override init() {
        super.init()
        setupAudioSessionForSpeaking()
    }
    
    // MARK: - Methods
    func speak(message: String) {
        guard let synthesizer = synthesizer else { return }
        if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: message)
            synthesizer.speak(utterance)
        }
    }
    
    private func setupAudioSessionForSpeaking() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        }
        catch _ {
            print("AudioSession exception")
        }
    }
}
