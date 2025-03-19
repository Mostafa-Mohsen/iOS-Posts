//
//  PostsListUseCaseMock.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import Combine
@testable import Posts

class PostsListUseCaseMock: PostsListUseCase {
    var userRepository: FetchUserRepository { return mockRepository }
    var mockRepository: PostsRepositoryMock
    var shouldFailToFetch = false
    
    init(mockRepository: PostsRepositoryMock) {
        self.mockRepository = mockRepository
    }
    
    func execute(requestValue: Posts.PostsUseCaseRequestValue) -> AnyPublisher<Posts.PostsPage?, Posts.NetworkError> {
        mockRepository.shouldFailToFetch = shouldFailToFetch
        return mockRepository.getPosts(limit: requestValue.limit, skip: requestValue.skip)
    }
}
