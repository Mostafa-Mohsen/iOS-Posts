//
//  AuthSceneDIContainer.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import UIKit
import SwiftUI

final class AuthSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var logInStorage: LogInResponseStorage = KeyChainLogInResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeLogInUseCase() -> LogInUseCase {
        DefaultLogInUseCase(logInRepository: makeLogInRepository())
    }
    
    // MARK: - Repositories
    func makeLogInRepository() -> LogInRepository {
        DefaultLogInRepository(networkService: dependencies.networkService,
                               cache: logInStorage)
    }
    
    // MARK: - Log In
    func makeLogInViewController(actions: LogInViewModelActions) -> UIViewController {
        let view = LogInView(
            viewModelWrapper: makeLogInViewModelWrapper(actions: actions))
        return UIHostingController(rootView: view)
    }
    
    func makeLogInViewModelWrapper(actions: LogInViewModelActions) -> LogInViewModelWrapper {
        return LogInViewModelWrapper(viewModel: makeLogInViewModel(actions: actions))
    }
    
    func makeLogInViewModel(actions: LogInViewModelActions) -> LogInViewModel {
        DefaultLogInViewModel(logInUseCase: makeLogInUseCase(),
                              actions: actions)
    }
    
    
}


