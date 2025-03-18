//
//  PostsRepository.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

protocol PostsRepository: FetchUserRepository {
    func getPosts(limit: Int, skip: Int) -> AnyPublisher<PostsPage?, NetworkError>
}
