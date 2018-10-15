//
//  AssistantViewController.swift
//  WeatherAssist
//
//  Created by Bassel Ezzeddine on 26/05/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit

protocol AssistantViewControllerIn {
}

protocol AssistantViewControllerOut {
    func executeTasksWaitingViewToLoad()
}

class AssistantViewController: UIViewController {

    // MARK: - Properties
    var interactor: AssistantViewControllerOut?
    private let configurator = AssistantConfigurator()
    
    // MARK: - UIViewController
    override func awakeFromNib() {
        super.awakeFromNib()
        configurator.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.executeTasksWaitingViewToLoad()
    }
}

// MARK: - ManageInternetServicesViewControllerIn
extension AssistantViewController: AssistantViewControllerIn {
}
