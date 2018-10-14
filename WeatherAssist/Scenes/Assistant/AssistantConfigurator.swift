//
//  AssistantConfigurator.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

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
        let presenter = AssistantPresenter()
        presenter.viewController = viewController
        presenter.speaker = Speaker()
        
        let interactor = AssistantInteractor()
        interactor.presenter = presenter
        interactor.voiceListener = VoiceListener()
        interactor.weatherWorker = WeatherWorker()
        
        viewController.interactor = interactor
    }
}
