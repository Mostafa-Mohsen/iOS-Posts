//
//  SearchPostsRequestDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
struct SearchPostsRequestDTO {
    enum SearchPostsRequestDTOKeys: String {
        case query = "q"
        case limit
        case skip
    }
    let query: String
    let limit: Int
    let skip: Int
}

extension SearchPostsRequestDTO {
    func getDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict[SearchPostsRequestDTOKeys.query.rawValue] = query as AnyObject
        dict[SearchPostsRequestDTOKeys.limit.rawValue] = limit as AnyObject
        dict[SearchPostsRequestDTOKeys.skip.rawValue] = skip as AnyObject
        
        return dict
    }
}
