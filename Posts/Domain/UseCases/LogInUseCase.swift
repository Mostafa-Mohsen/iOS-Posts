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


struct LogInsUseCaseRequestValue {
    let name: String
    let password: String
}
