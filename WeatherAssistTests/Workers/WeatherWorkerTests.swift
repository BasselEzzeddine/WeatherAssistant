//
//  WeatherWorkerTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 27/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import WeatherAssist

class WeatherWorkerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: WeatherWorker!
    let mockServer = MockServer()
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        mockServer.stop()
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = WeatherWorker()
    }
    
    // MARK: - Tests
    func testCallingFetchCurrentWeather_ReturnsCorrectData() {
        // Given
        mockServer.respondToGetWeather()
        mockServer.start()
        
        // When
        let expectation = self.expectation(description: "Wait server response")
        sut.fetchCurrentWeather(completionHandler: {
            (rawWeather: RawWeather?, success: Bool) in
            
            // Then
            XCTAssertNotNil(rawWeather)
            XCTAssertEqual(rawWeather?.main.temp, 25)
            XCTAssertEqual(rawWeather?.main.pressure, 1000)
            XCTAssertEqual(rawWeather?.main.humidity, 50)
            XCTAssertTrue(success)
            
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
}
