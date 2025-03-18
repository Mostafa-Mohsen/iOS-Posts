//
//  LogInViewModel.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

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
