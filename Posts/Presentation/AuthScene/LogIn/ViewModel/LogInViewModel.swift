//
//  LogInViewModel.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

struct LogInViewModelActions {
    let showPostsList: () -> Void
}

protocol LogInViewModelInput {
    func didClickLogInWith(name: String, password: String)
}

protocol LogInViewModelOutput {
    var errorTitle: String { get }
    var welcomeImage: String { get }
    var welcomeText: String { get }
    var nameText: String { get }
    var nameFieldPlaceholder: String { get }
    var passwordText: String { get }
    var passwordFieldPlaceholder: String { get }
    var showPasswordImage: String { get }
    var hidePasswordImage: String { get }
    var signInButtonText: String { get }
    var screenTitle: String { get }
    var error: PassthroughSubject<String, Never> { get }
    var errorDismissText: String { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
}

typealias LogInViewModel = LogInViewModelInput & LogInViewModelOutput

final class DefaultLogInViewModel: LogInViewModelOutput {
    
    private let logInUseCase: LogInUseCase
    private let actions: LogInViewModelActions?
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - OUTPUT
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    let error = PassthroughSubject<String, Never>()
    let errorTitle = "Error"
    let errorDismissText = "Ok"
    let screenTitle = "Log In"
    let welcomeImage = "signin-image"
    let welcomeText = "Welcome"
    let nameText = "User Name"
    let nameFieldPlaceholder = "Enter your user name"
    let passwordText = "Password"
    let passwordFieldPlaceholder = "Enter user password"
    let showPasswordImage = "eye"
    let hidePasswordImage = "eye.slash"
    var signInButtonText = "Sign in"
    
    // MARK: - Init
    init(logInUseCase: LogInUseCase,
         actions: LogInViewModelActions? = nil) {
        self.logInUseCase = logInUseCase
        self.actions = actions
    }
    
    private func authUserWith(name: String, password: String) {
        isLoading.send(true)
        logInUseCase.execute(requestValue: .init(name: name, password: password))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading.send(false)
                    self.actions?.showPostsList()
                case .failure(let error):
                    self.isLoading.send(false)
                    self.handle(error: error)
                }
                
            }, receiveValue: { _ in })
            .store(in: &cancellable)
    }
    
    private func handle(error: NetworkError) {
        switch error {
        case .error(_):
            self.error.send("Failed to log in\nPlease check your user name and password")
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultLogInViewModel: LogInViewModelInput {
    func didClickLogInWith(name: String, password: String) {
        authUserWith(name: name, password: password)
    }
}
