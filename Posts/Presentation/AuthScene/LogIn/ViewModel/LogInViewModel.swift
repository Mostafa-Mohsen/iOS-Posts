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


