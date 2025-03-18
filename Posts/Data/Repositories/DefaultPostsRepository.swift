//
//  DefaultPostsRepository.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

final class DefaultPostsRepository {

    internal let networkService: NetworkService
    
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultPostsRepository: PostsRepository {
    func getPosts(limit: Int, skip: Int) -> AnyPublisher<PostsPage?, NetworkError> {
        let requestDTO = PostsRequestDTO(limit: limit, skip: skip)
        let endpoint = APIEndpoints.getPosts(with: requestDTO)
        
        return networkService.request(endPoint: endpoint, type: PostsResponseDTO.self)
            .map{ (postsResponse) -> PostsPage? in
                guard let unwrappedPosts = postsResponse else { return nil }
                return unwrappedPosts.toDomain()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
