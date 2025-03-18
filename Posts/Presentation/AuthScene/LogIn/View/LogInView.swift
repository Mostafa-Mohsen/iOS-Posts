//
//  LogInView.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import SwiftUI
import Combine


final class LogInViewModelWrapper: ObservableObject {
    var viewModel: LogInViewModel?
    @Published var name: String = ""
    @Published var passowrd: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showLoading: Bool = false
    private var cancellable: [AnyCancellable] = []
    var isLogInDisabled: Bool {
        return name.isEmpty || passowrd.isEmpty
    }

    
    init(viewModel: LogInViewModel?) {
        self.viewModel = viewModel
        self.viewModel?.error.sink {
            self.alertMessage = $0
            self.showAlert = true
        }
        .store(in: &cancellable)
        self.viewModel?.isLoading.sink {
            self.showLoading = $0
        }
        .store(in: &cancellable)
    }
    
    func logInUser() {
        viewModel?.didClickLogInWith(name: name, password: passowrd)
    }
}

