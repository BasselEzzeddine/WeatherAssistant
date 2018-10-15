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
        sut = AssistantInteractor()
    }
    
    // MARK: - Spies
    class AssistantPresenterSpy: AssistantInteractorOut {
        var presentWelcomeMessageCalled = false
        
        var presentWeatherMessageCalled = false
        var presentWeatherMessageResponse: AssistantModel.Fetch.Response?
        
        var presentErrorMessageCalled = false
        
        func presentWelcomeMessage() {
            presentWelcomeMessageCalled = true
        }
        
        func presentWeatherMessage(_ response: AssistantModel.Fetch.Response) {
            presentWeatherMessageCalled = true
            presentWeatherMessageResponse = response
        }
        
        func presentErrorMessage() {
            presentErrorMessageCalled = true
        }
    }
    
    class VoiceListenerSpy: VoiceListener {
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
    
    class WeatherWorkerSpy: WeatherWorker {
        var fetchCurrentWeatherCalled = false
        var rawWeatherToBeReturned: RawWeather?
        var successToBeReturned = false
        
        override func fetchCurrentWeather(completionHandler: @escaping(_ rawWeather: RawWeather?, _ success: Bool) -> Void) {
            fetchCurrentWeatherCalled = true
            completionHandler(rawWeatherToBeReturned, successToBeReturned)
        }
    }
    
    // MARK: - Tests
    func testCallingExecuteTasksWaitingViewToLoad_CallsPresentWelcomeMessageInPresenter() {
        // Given
        let presenterSpy = AssistantPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(presenterSpy.presentWelcomeMessageCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsSetupVoiceListeningInVoiceListener() {
        // Given
        let voiceListenerSpy = VoiceListenerSpy()
        sut.voiceListener = voiceListenerSpy
        
        // When
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(voiceListenerSpy.setupVoiceListeningCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsStartListeningInVoiceListener_WhenSetupVoiceListeningIsSuccessful() {
        // Given
        let voiceListenerSpy = VoiceListenerSpy()
        sut.voiceListener = voiceListenerSpy
        
        // When
        voiceListenerSpy.isSuccessfulToBeReturned = true
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(voiceListenerSpy.startListeningCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsFetchCurrentWeatherInWorker_WhenRecognizedWordIsWeather() {
        // Given
        let voiceListenerSpy = VoiceListenerSpy()
        sut.voiceListener = voiceListenerSpy
        
        let weatherWorkerSpy = WeatherWorkerSpy()
        sut.weatherWorker = weatherWorkerSpy
        
        // When
        voiceListenerSpy.isSuccessfulToBeReturned = true
        voiceListenerSpy.recognizedWordToBeReturned = "Weather"
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(weatherWorkerSpy.fetchCurrentWeatherCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsPresentWeatherMessageInPresenterWithCorrectData_WhenResponseFromWorkerIsSuccessAndIsNotNil() {
        // Given
        let voiceListenerSpy = VoiceListenerSpy()
        sut.voiceListener = voiceListenerSpy
        
        let weatherWorkerSpy = WeatherWorkerSpy()
        sut.weatherWorker = weatherWorkerSpy
        
        let presenterSpy = AssistantPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        let main = RawWeather.Main(temp: 25, pressure: 1000, humidity: 50)
        weatherWorkerSpy.rawWeatherToBeReturned = RawWeather(main: main)
        weatherWorkerSpy.successToBeReturned = true
        
        voiceListenerSpy.isSuccessfulToBeReturned = true
        voiceListenerSpy.recognizedWordToBeReturned = "Weather"
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(presenterSpy.presentWeatherMessageCalled)
        XCTAssertEqual(presenterSpy.presentWeatherMessageResponse?.temperature, 25)
        XCTAssertEqual(presenterSpy.presentWeatherMessageResponse?.pressure, 1000)
        XCTAssertEqual(presenterSpy.presentWeatherMessageResponse?.humidity, 50)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsPresentErrorMessageInPresenter_WhenResponseFromWorkerIsNotSuccess() {
        // Given
        let voiceListenerSpy = VoiceListenerSpy()
        sut.voiceListener = voiceListenerSpy
        
        let weatherWorkerSpy = WeatherWorkerSpy()
        sut.weatherWorker = weatherWorkerSpy
        
        let presenterSpy = AssistantPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        let main = RawWeather.Main(temp: 25, pressure: 1000, humidity: 50)
        weatherWorkerSpy.rawWeatherToBeReturned = RawWeather(main: main)
        weatherWorkerSpy.successToBeReturned = false
        
        voiceListenerSpy.recognizedWordToBeReturned = "Weather"
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorMessageCalled)
    }
    
    func testCallingExecuteTasksWaitingViewToLoad_CallsPresentErrorMessageInPresenter_WhenResponseFromWorkerIsSuccessAndIsNil() {
        // Given
        let voiceListenerSpy = VoiceListenerSpy()
        sut.voiceListener = voiceListenerSpy
        
        let weatherWorkerSpy = WeatherWorkerSpy()
        sut.weatherWorker = weatherWorkerSpy
        
        let presenterSpy = AssistantPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        weatherWorkerSpy.rawWeatherToBeReturned = nil
        weatherWorkerSpy.successToBeReturned = true
        
        voiceListenerSpy.recognizedWordToBeReturned = "Weather"
        sut.executeTasksWaitingViewToLoad()
        
        RunLoop.current.run(mode: RunLoop.Mode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1)) // Wait a little
        
        // Then
        XCTAssertTrue(presenterSpy.presentErrorMessageCalled)
    }
}
