//
//  LogInRepository.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

protocol LogInRepository {
    func authUserWith(name: String, password: String) -> AnyPublisher<LogInToken?, NetworkError>
}
