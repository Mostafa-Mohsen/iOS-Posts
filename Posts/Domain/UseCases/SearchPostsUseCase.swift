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



struct SearchPostsUseCaseRequestValue {
    let limit: Int
    let skip: Int
    let query: String
}
