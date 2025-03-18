//
//  KeyChainLogInResponseStorage.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import Combine

enum KeyChainKeys: String {
    case authKey = "com.m-m-m.Posts.authKey"
}

final class KeyChainLogInResponseStorage {
    
    private let keyChainStorage: KeyChainStorage
    
    init(keyChainStorage: KeyChainStorage = KeyChainStorage.shared) {
        self.keyChainStorage = keyChainStorage
    }
    
    // MARK: - Private
    private func getLogInEntity() -> LogInEntityKCS? {
        guard let data = keyChainStorage.retrieve(key: KeyChainKeys.authKey.rawValue),
              let logInEntity = try? JSONDecoder().decode(LogInEntityKCS.self, from: data) else { return nil }
        return logInEntity
    }
}

extension KeyChainLogInResponseStorage: LogInResponseStorage {
    func getLogInResponse() -> AnyPublisher<LogInResponseDTO?, Never> {
        return Just(getLogInEntity()?.toDomain())
            .eraseToAnyPublisher()
    }
    
    func save(response: LogInResponseDTO) {
        let entity = LogInEntityKCS(accessToken: response.accessToken,
                                    refreshToken: response.refreshToken,
                                    timeStamp: Date())
        if let data = try? JSONEncoder().encode(entity) {
            keyChainStorage.save(key: KeyChainKeys.authKey.rawValue, data: data)
        }
    }
}
