//
//  SearchPostsRepository.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import Combine

protocol SearchPostsRepository: FetchUserRepository {
    func getPosts(query: String, limit: Int, skip: Int) -> AnyPublisher<PostsPage?, NetworkError>
}
