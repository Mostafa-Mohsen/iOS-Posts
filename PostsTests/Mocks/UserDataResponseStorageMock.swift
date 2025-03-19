//
//  UserDataResponseStorageMock.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import Combine
@testable import Posts

class UserDataResponseStorageMock: UserDataResponseStorage {
    var storedData: FetchUserDataResponseDTO?
    
    func getResponse(for request: Posts.FetchUserDataRequestDTO) -> AnyPublisher<Posts.FetchUserDataResponseDTO?, Posts.CoreDataStorageError> {
        return Just(storedData)
            .setFailureType(to: CoreDataStorageError.self)
            .eraseToAnyPublisher()
    }
    
    func save(response: Posts.FetchUserDataResponseDTO, for request: Posts.FetchUserDataRequestDTO) {
        storedData = response
    }
}
