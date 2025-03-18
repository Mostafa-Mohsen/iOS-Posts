//
//  LogInResponseDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation

// MARK: - Data Transfer Object
struct LogInResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

// MARK: - Mappings to Domain
extension LogInResponseDTO {
    func toDomain() -> LogInToken {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
