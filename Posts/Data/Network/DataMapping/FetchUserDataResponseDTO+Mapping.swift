//
//  FetchUserDataResponseDTO+Mapping.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation

struct FetchUserDataResponseDTO: Decodable {
    let id: Int
    let firstName: String?
    let lastName: String?
}

// MARK: - Mappings to Domain
extension FetchUserDataResponseDTO {
    func toDomain() -> UserData {
        return .init(id: id, firstName: firstName, lastName: lastName)
    }
}
