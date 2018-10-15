//
//  AssistantInteractorTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import WeatherAssist

class AssistantInteractorTests: XCTestCase {
    
    // MARK: - Properties
    var sut: AssistantInteractor!
    
    // MARK: - Mocks
    class AssistantPresenterMock: AssistantInteractorOut {
        var presentWelcomeMessageCalled = false
        
        var presentWeatherMessageCalled = false
        var presentWeatherMessageResponse: AssistantModel.Response?
        
        var presentErrorMessageCalled = false
        
        func presentWelcomeMessage() {
            presentWelcomeMessageCalled = true
        }
        
        func presentWeatherMessage(response: AssistantModel.Response) {
            presentWeatherMessageCalled = true
            presentWeatherMessageResponse = response
        }
        
        func presentErrorMessage() {
            presentErrorMessageCalled = true
        }
    }
    
    class VoiceListenerMock: VoiceListener {
        var setupVoiceListeningCalled = false
        var isSuccessfulToBeReturned = false
        
        var startListeningCalled = false
        var recognizedWordToBeReturned = ""
        
        override func setupVoiceListening(completionHandler: @escaping(_ isSuccessful: Bool) -> Void) {
            setupVoiceListeningCalled = true
            completionHandler(isSuccessfulToBeReturned)
        }
        
        override func startListening(completionHandler: @escaping (_ recognizedWord: String) -> Void) {
            startListeningCalled = true
            completionHandler(recognizedWordToBeReturned)
        }
    }
    
    class WeatherWorkerMock: WeatherWorker {
        var fetchCurrentWeatherCalled = false
        var rawWeatherToBeReturned: RawWeather?
        var successToBeReturned = false
        
        override func fetchCurrentWeather(completionHandler: @escaping(_ rawWeather: RawWeather?, _ success: Bool) -> Void) {
            fetchCurrentWeatherCalled = true
            completionHandler(rawWeatherToBeReturned, successToBeReturned)
        }
    }
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = AssistantInteractor()
    }
    
    // MARK: - Tests
    func testCallingExecuteTasksWaitingViewToLoad_CallsPresentWelcomeMessageInPresenter() {
        // Given
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(presenterMock.presentWelcomeMessageCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsSetupVoiceListeningInVoiceListener() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(voiceListenerMock.setupVoiceListeningCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsStartListeningInVoiceListener_WhenSetupVoiceListeningIsSuccessful() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        // When
        voiceListenerMock.isSuccessfulToBeReturned = true
        sut.executeTasksWaitingViewToLoad()
        
        // Then
        XCTAssertTrue(voiceListenerMock.startListeningCalled)
    }
    
    func testCallingStartListeningToUserAndRecognizingWords_CallsFetchCurrentWeatherInWorker_WhenRecognizedWordIsWeather() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        let weatherWorkerMock = WeatherWorkerMock()
        sut.weatherWorker = weatherWorkerMock
        
        // When
        voiceListenerMock.recognizedWordToBeReturned = "Weather"
        sut.startListeningToUserAndRecognizingWords()
        
        // Then
        XCTAssertTrue(weatherWorkerMock.fetchCurrentWeatherCalled)
    }
    
    func testCallingStartListeningToUserAndRecognizingWords_CallsPresentWeatherMessageInPresenterWithCorrectData_WhenResponseFromWorkerIsSuccessAndIsNotNil() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        let weatherWorkerMock = WeatherWorkerMock()
        sut.weatherWorker = weatherWorkerMock
        
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        let main = RawWeather.Main(temp: 25, pressure: 1000, humidity: 50)
        weatherWorkerMock.rawWeatherToBeReturned = RawWeather(main: main)
        weatherWorkerMock.successToBeReturned = true
        
        voiceListenerMock.recognizedWordToBeReturned = "Weather"
        sut.startListeningToUserAndRecognizingWords()
        
        // Then
        XCTAssertTrue(presenterMock.presentWeatherMessageCalled)
        XCTAssertEqual(presenterMock.presentWeatherMessageResponse?.temperature, 25)
        XCTAssertEqual(presenterMock.presentWeatherMessageResponse?.pressure, 1000)
        XCTAssertEqual(presenterMock.presentWeatherMessageResponse?.humidity, 50)
    }
    
    func testCallingStartListeningToUserAndRecognizingWords_CallsPresentErrorMessageInPresenter_WhenResponseFromWorkerIsNotSuccess() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        let weatherWorkerMock = WeatherWorkerMock()
        sut.weatherWorker = weatherWorkerMock
        
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        let main = RawWeather.Main(temp: 25, pressure: 1000, humidity: 50)
        weatherWorkerMock.rawWeatherToBeReturned = RawWeather(main: main)
        weatherWorkerMock.successToBeReturned = false
        
        voiceListenerMock.recognizedWordToBeReturned = "Weather"
        sut.startListeningToUserAndRecognizingWords()
        
        // Then
        XCTAssertTrue(presenterMock.presentErrorMessageCalled)
    }
    
    func testCallingStartListeningToUserAndRecognizingWords_CallsPresentErrorMessageInPresenter_WhenResponseFromWorkerIsSuccessAndIsNil() {
        // Given
        let voiceListenerMock = VoiceListenerMock()
        sut.voiceListener = voiceListenerMock
        
        let weatherWorkerMock = WeatherWorkerMock()
        sut.weatherWorker = weatherWorkerMock
        
        let presenterMock = AssistantPresenterMock()
        sut.presenter = presenterMock
        
        // When
        weatherWorkerMock.rawWeatherToBeReturned = nil
        weatherWorkerMock.successToBeReturned = true
        
        voiceListenerMock.recognizedWordToBeReturned = "Weather"
        sut.startListeningToUserAndRecognizingWords()
        
        // Then
        XCTAssertTrue(presenterMock.presentErrorMessageCalled)
    }
}
