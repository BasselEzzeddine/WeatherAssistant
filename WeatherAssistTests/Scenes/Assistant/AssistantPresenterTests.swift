//
//  AssistantPresenterTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import WeatherAssist

class AssistantPresenterTests: XCTestCase {
    
    // MARK: - Properties
    var sut: AssistantPresenter!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Methods
    func setupSUT() {
        sut = AssistantPresenter()
    }
    
    // MARK: - Spies
    class SpeakerSpy: Speaker {
        var speakCalled = false
        var messagePassed = ""
        
        override func speak(message: String) {
            speakCalled = true
            messagePassed = message
        }
    }
    
    // MARK: - Tests
    func testCallingPresentWelcomeMessage_CallsSpeakInSpeakerWithCorrectData() {
        // Given
        let speakerSpy = SpeakerSpy()
        sut.speaker = speakerSpy
        
        // When
        sut.presentWelcomeMessage()
        
        // Then
        XCTAssertTrue(speakerSpy.speakCalled)
        XCTAssertEqual(speakerSpy.messagePassed, "Hello, please express your demand")
    }
    
    func testCallingPresentWeatherMessage_CallsSpeakInSpeakerWithCorrectData() {
        // Given
        let speakerSpy = SpeakerSpy()
        sut.speaker = speakerSpy
        
        // When
        let response = AssistantModel.Fetch.Response(temperature: 25, pressure: 1000, humidity: 50)
        sut.presentWeatherMessage(response)
        
        // Then
        XCTAssertTrue(speakerSpy.speakCalled)
        XCTAssertEqual(speakerSpy.messagePassed, "Current temperature in Berlin is 25 degrees celsius with pressure of 1000 Hectopascals, and 50 percent humidity")
    }
    
    func testCallingPresentErrorMessage_CallsSpeakInSpeakerWithCorrectData() {
        // Given
        let speakerSpy = SpeakerSpy()
        sut.speaker = speakerSpy
        
        // When
        sut.presentErrorMessage()
        
        // Then
        XCTAssertTrue(speakerSpy.speakCalled)
        XCTAssertEqual(speakerSpy.messagePassed, "I am sorry an error occured, please try again later")
    }
}
