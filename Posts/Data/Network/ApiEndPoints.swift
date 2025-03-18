//
//  ApiEndPoints.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Alamofire

struct APIEndpoints {
    enum Paths: String {
        case LogIn = "/auth/login"
        case Posts = "/posts"
        
        var headers: [String: String] {
            switch self {
            case .LogIn:
                return ["Content-Type": "application/json"]
            default:
                return [:]
            }
        }
    }
    
    static func authUser(with logInRequestDTO: LogInRequestDTO) -> Endpoint {
        return Endpoint(
            path: Paths.LogIn.rawValue,
            method: .post,
            headers: Paths.LogIn.headers,
            encoding: JSONEncoding.default,
            parameters: logInRequestDTO.getDictionary()
        )
    }
    
    static func getPosts(with postsRequestDTO: PostsRequestDTO) -> Endpoint {
        return Endpoint(
            path: Paths.Posts.rawValue,
            method: .get,
            parameters: postsRequestDTO.getDictionary()
        )
    }
    
    
    
}
