//
//  FetchPostsUseCase.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation
import Combine

protocol PostsListUseCase: FetchUserUseCase {
    func execute(requestValue: PostsUseCaseRequestValue) -> AnyPublisher<PostsPage?, NetworkError>
}

final class DefaultPostsUseCase {
    private let postsRepository: PostsRepository
    var userRepository: FetchUserRepository { return postsRepository }
    
    init(postsRepository: PostsRepository) {
        self.postsRepository = postsRepository
    }
}

extension DefaultPostsUseCase: PostsListUseCase {
    func execute(requestValue: PostsUseCaseRequestValue) -> AnyPublisher<PostsPage?, NetworkError> {
        return postsRepository.getPosts(limit: requestValue.limit,
                                        skip: requestValue.skip)
    }
}

struct PostsUseCaseRequestValue {
    let limit: Int
    let skip: Int
}
