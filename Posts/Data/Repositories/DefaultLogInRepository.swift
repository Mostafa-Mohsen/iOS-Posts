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
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultLogInRepository: LogInRepository {
    func authUserWith(name: String, password: String) -> AnyPublisher<LogInToken?, NetworkError> {
        let requestDTO = LogInRequestDTO(username: name, password: password)
        let endpoint = APIEndpoints.authUser(with: requestDTO)
        
        return networkService.request(endPoint: endpoint, type: LogInResponseDTO.self)
            .map{ (logInResponse) -> LogInToken? in
                guard let unwrappedResponse = logInResponse else { return nil }
                return unwrappedResponse.toDomain()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
