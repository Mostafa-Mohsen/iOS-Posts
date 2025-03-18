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

struct PostsUseCaseRequestValue {
    let limit: Int
    let skip: Int
}
