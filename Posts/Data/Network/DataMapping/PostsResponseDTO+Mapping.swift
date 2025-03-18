//
//  PostsResponseDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation

// MARK: - Data Transfer Object
struct PostsResponseDTO: Decodable {
    let posts: [PostDTO]
    let skip: Int
    let limit: Int
    let total: Int
}

extension PostsResponseDTO {
    struct PostDTO: Decodable {
        let id: Int
        let body: String?
        let userId: Int?
    }
}

// MARK: - Mappings to Domain
extension PostsResponseDTO {
    func toDomain() -> PostsPage {
        return .init(posts: posts.map { $0.toDomain() },
                     PostPagination: PostPagination(skip: skip,
                                                    limit: limit),
                     total: total)
    }
}

extension PostsResponseDTO.PostDTO {
    func toDomain() -> Post {
        return .init(id: id,
                     body: body,
                     userId: userId)
    }
}
