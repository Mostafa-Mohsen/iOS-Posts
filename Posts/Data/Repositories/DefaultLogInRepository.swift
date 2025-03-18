//
//  DefaultLogInRepository.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Combine

final class DefaultLogInRepository {

    private let networkService: NetworkService
    private let cache: LogInResponseStorage
    
    init(networkService: NetworkService, cache: LogInResponseStorage) {
        self.networkService = networkService
        self.cache = cache
    }
}

extension DefaultLogInRepository: LogInRepository {
    func authUserWith(name: String, password: String) -> AnyPublisher<LogInToken?, NetworkError> {
        let requestDTO = LogInRequestDTO(username: name, password: password)
        let endpoint = APIEndpoints.authUser(with: requestDTO)
        
        return networkService.request(endPoint: endpoint, type: LogInResponseDTO.self)
            .map{ (logInResponse) -> LogInToken? in
                guard let unwrappedResponse = logInResponse else { return nil }
                self.cache.save(response: unwrappedResponse)
                return unwrappedResponse.toDomain()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
