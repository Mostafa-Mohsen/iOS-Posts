//
//  FetchUserUseCase.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import Combine

protocol FetchUserUseCase {
    var userRepository: FetchUserRepository { get }
    func execute(requestValue: FetchUsersUseCaseRequestValue) -> AnyPublisher<[UserData?], Never>
}

extension FetchUserUseCase {
    func execute(requestValue: FetchUsersUseCaseRequestValue) -> AnyPublisher<[UserData?], Never> {
        return userRepository.getUsersBy(ids: requestValue.ids)
    }
}

struct FetchUsersUseCaseRequestValue {
    let ids: [Int]
}
