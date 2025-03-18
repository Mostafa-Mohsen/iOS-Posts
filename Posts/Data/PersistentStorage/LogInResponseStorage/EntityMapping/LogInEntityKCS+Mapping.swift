//
//  LogInEntityKCS+Mapping.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation

struct LogInEntityKCS: Codable {
    let accessToken: String
    let refreshToken: String
    let timeStamp: Date
}

extension LogInEntityKCS {
    func toDomain() -> LogInResponseDTO {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}

