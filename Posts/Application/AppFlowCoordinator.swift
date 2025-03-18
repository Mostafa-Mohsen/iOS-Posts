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

    func start() {
//        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
//        let flow = authSceneDIContainer.makeLogInFlowCoordinator(navigationController: navigationController)
//        flow.start()
      
        startPostsScene()
       
    }
    
    func startPostsScene() {
        let postsSceneDIContainer = appDIContainer.makePostsSceneDIContainer()
        let flow = postsSceneDIContainer.makePostsFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
