//
//  DefaultSearchPostsRepository.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import Combine

final class DefaultSearchPostsRepository {

    internal let networkService: NetworkService
    internal let cache: UserDataResponseStorage
    
    init(networkService: NetworkService, cache: UserDataResponseStorage) {
        self.networkService = networkService
        self.cache = cache
    }
}

extension DefaultSearchPostsRepository: SearchPostsRepository {
    func getPosts(query: String, limit: Int, skip: Int) -> AnyPublisher<PostsPage?, NetworkError> {
        let requestDTO = SearchPostsRequestDTO(query: query, limit: limit, skip: skip)
        let endpoint = APIEndpoints.searchPosts(with: requestDTO)
        
        return networkService.request(endPoint: endpoint, type: PostsResponseDTO.self)
            .map{ (postsResponse) -> PostsPage? in
                guard let unwrappedPosts = postsResponse else { return nil }
                return unwrappedPosts.toDomain()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
