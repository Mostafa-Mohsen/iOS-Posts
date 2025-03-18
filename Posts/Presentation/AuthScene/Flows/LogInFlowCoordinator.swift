//
//  LogInFlowCoordinator.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import UIKit

protocol LogInFlowCoordinatorDependencies  {
    func makeLogInViewController(actions: LogInViewModelActions) -> UIViewController
}

final class LogInFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: LogInFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: LogInFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}
