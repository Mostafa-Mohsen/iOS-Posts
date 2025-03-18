//
//  PostsListItemViewModel.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation

struct PostsListItemViewModel: Identifiable {
    let id: Int
    let profileImage: String
    let postImages: [String]
    let body: String
    let firstName: String
    let lastName: String
    
    var fullName: String {
        [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

extension PostsListItemViewModel {
    init(post: Post) {
        id = post.id
        profileImage = PostsListItemViewModel.getProfileImage()
        postImages = Array(PostsListItemViewModel.getPostImages().prefix(Int.random(in: 1...4)))
        body = post.body ?? ""
        firstName = ""
        lastName = ""
    }
    
    private static func getProfileImage() -> String {
        let images = [
            "profileImage-1",
            "profileImage-2",
            "profileImage-3",
            "profileImage-4"
        ]
        return images[Int.random(in: 0...3)]
    }
    
    private static func getPostImages() -> [String] {
        let images = [
            "postImage-1",
            "postImage-2",
            "postImage-3",
            "postImage-4"
        ]
        return images
    }
}
