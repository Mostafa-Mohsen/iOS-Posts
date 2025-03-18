//
//  UserDataResponseStorage.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import Combine

protocol UserDataResponseStorage {
    func getResponse(for request: FetchUserDataRequestDTO) -> AnyPublisher<FetchUserDataResponseDTO?, CoreDataStorageError>
    func save(response: FetchUserDataResponseDTO, for request: FetchUserDataRequestDTO)
}
