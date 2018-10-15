//
//  AssistantViewControllerTests.swift
//  WeatherAssistTests
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import WeatherAssist

class AssistantViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: AssistantViewController!
    
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "AssistantViewController") as? AssistantViewController
        UIApplication.shared.keyWindow?.rootViewController = sut
    }
    
    // MARK: - Spies
    class AssistantInteractorSpy: AssistantViewControllerOut {
        var executeTasksWaitingViewToLoadCalled = false
        
        func executeTasksWaitingViewToLoad() {
            executeTasksWaitingViewToLoadCalled = true
        }
    }
    
    // MARK: - Tests
    func testWhenViewLoads_CallsExecuteTasksWaitingViewToLoadInInteractor() {
        // Given
        let interactorSpy = AssistantInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(interactorSpy.executeTasksWaitingViewToLoadCalled)
    }
}
