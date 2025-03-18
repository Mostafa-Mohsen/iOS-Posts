//
//  Post.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation

struct PostsPage {
    let posts: [Post]
    let PostPagination: PostPagination
    let total: Int
}

struct Post: Identifiable {
    let id: Int
    let body: String?
    let userId: Int?
}

struct PostPagination {
    let skip: Int
    let limit: Int
}
