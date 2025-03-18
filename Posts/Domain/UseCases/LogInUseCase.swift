//
//  LogInUseCase.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

protocol LogInUseCase {
    func execute(requestValue: LogInsUseCaseRequestValue) -> AnyPublisher<LogInToken?, NetworkError>
}

final class DefaultLogInUseCase {
    private let logInRepository: LogInRepository
    
    init(logInRepository: LogInRepository) {
        self.logInRepository = logInRepository
    }
}

extension DefaultLogInUseCase: LogInUseCase {
    func execute(requestValue: LogInsUseCaseRequestValue) -> AnyPublisher<LogInToken?, NetworkError> {
        return logInRepository.authUserWith(name: requestValue.name, password: requestValue.password)
    }
}

struct LogInsUseCaseRequestValue {
    let name: String
    let password: String
}
