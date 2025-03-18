//
//  AppDIContainer.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var networkService: NetworkService = {
        let config = ApiDataNetworkConfig(baseURL: appConfiguration.apiBaseURL)
        return DefaultNetworkService(config: config)
    }()
    
    // MARK: - DIContainers of scenes
    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        let dependencies = AuthSceneDIContainer.Dependencies(networkService: networkService)
        return AuthSceneDIContainer(dependencies: dependencies)
    }
}
