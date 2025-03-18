//
//  FetchUserDataRequestDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
struct FetchUserDataRequestDTO {
    enum RequestDTOKeys: String {
        case select
        case firstName
        case lastName
    }
    let id: Int
}

extension FetchUserDataRequestDTO {
    func getDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict[RequestDTOKeys.select.rawValue] = [
            RequestDTOKeys.firstName.rawValue,
            RequestDTOKeys.lastName.rawValue
        ] as AnyObject
        
        return dict
    }
}
