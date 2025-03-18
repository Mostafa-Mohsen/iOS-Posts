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


