//
//  PostsRequestDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation

struct PostsRequestDTO {
    enum PostsRequestDTOKeys: String {
        case limit
        case skip
    }
    let limit: Int
    let skip: Int
}

extension PostsRequestDTO {
    func getDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict[PostsRequestDTO.PostsRequestDTOKeys.limit.rawValue] = limit as AnyObject
        dict[PostsRequestDTO.PostsRequestDTOKeys.skip.rawValue] = skip as AnyObject
        
        return dict
    }
}
