//
//  LogInRequestDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation

enum LogInTokenTTL: Int {
    case expiration = 60
}

struct LogInRequestDTO {
    enum LogInRequestDTOKeys: String {
        case username
        case password
        case expiresInMins
    }
    let username: String
    let password: String
    let expiresInMins: Int = LogInTokenTTL.expiration.rawValue
}

extension LogInRequestDTO {
    func getDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict[LogInRequestDTOKeys.username.rawValue] = username as AnyObject
        dict[LogInRequestDTOKeys.password.rawValue] = password as AnyObject
        dict[LogInRequestDTOKeys.expiresInMins.rawValue] = expiresInMins as AnyObject
        
        return dict
    }
}
