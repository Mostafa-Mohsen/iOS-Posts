//
//  LogInResponseStorage.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import Combine

protocol LogInResponseStorage {
    func getLogInResponse() -> AnyPublisher<LogInResponseDTO?, Never>
    func save(response: LogInResponseDTO)
}
