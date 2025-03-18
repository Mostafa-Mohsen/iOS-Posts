//
//  SearchPostsUseCase.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import Combine

protocol SearchPostsUseCase: FetchUserUseCase {
    func execute(requestValue: SearchPostsUseCaseRequestValue) -> AnyPublisher<PostsPage?, NetworkError>
}

final class DefaultSearchPostsUseCase {
    private let searchPostsRepository: SearchPostsRepository
    var userRepository: FetchUserRepository { return searchPostsRepository }
    
    init(searchPostsRepository: SearchPostsRepository) {
        self.searchPostsRepository = searchPostsRepository
    }
}

extension DefaultSearchPostsUseCase: SearchPostsUseCase {
    func execute(requestValue: SearchPostsUseCaseRequestValue) -> AnyPublisher<PostsPage?, NetworkError> {
        return searchPostsRepository.getPosts(query: requestValue.query,
                                              limit: requestValue.limit,
                                              skip: requestValue.skip)
    }
}

struct SearchPostsUseCaseRequestValue {
    let limit: Int
    let skip: Int
    let query: String
}
