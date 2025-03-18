//
//  UserDataEntity+Mapping.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import CoreData

extension UserDataEntity {
    func toDTO() -> FetchUserDataResponseDTO {
        return .init(id: Int(userId),
                     firstName: firstName,
                     lastName: lastName)
    }
}

extension FetchUserDataResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> UserDataEntity {
        let entity: UserDataEntity = .init(context: context)
        entity.userId = Int64(id)
        entity.firstName = firstName
        entity.lastName = lastName
        
        return entity
    }
}
