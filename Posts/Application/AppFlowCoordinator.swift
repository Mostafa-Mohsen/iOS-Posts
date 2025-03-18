//
//  AppFlowCoordinator.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
}
