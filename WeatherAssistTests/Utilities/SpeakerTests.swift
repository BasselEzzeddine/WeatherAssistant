//
//  SpeakerTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
import Speech
@testable import WeatherAssist

class SpeakerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: Speaker!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSut()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Methods
    func setupSut() {
        sut = Speaker()
    }
    
    // MARK: - Spies
    class SynthesizerSpy: AVSpeechSynthesizer {
        var speakCalled = false
        var speechStringPassed = ""
        
        override func speak(_ utterance: AVSpeechUtterance) {
            speakCalled = true
            speechStringPassed = utterance.speechString
        }
    }
    
    // MARK: - Tests
    func testCallingSpeakInSpeaker_CallsSpeakInSynthesizerWithCorrectData() {
        // Given
        let synthesizerSpy = SynthesizerSpy()
        sut.synthesizer = synthesizerSpy
        
        // When
        sut.speak(message: "Hello")
        
        // Then
        XCTAssertTrue(synthesizerSpy.speakCalled)
        XCTAssertEqual(synthesizerSpy.speechStringPassed, "Hello")
    }
}
