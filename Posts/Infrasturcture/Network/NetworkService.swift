//
//  NetworkService.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import Foundation
import Alamofire
import Combine

enum NetworkError: Error {
    case error(message: String)
}

protocol NetworkService {
    func request<T: Decodable>(endPoint: Requestable, type: T.Type) -> AnyPublisher<T?, NetworkError>
}

class DefaultNetworkService: NetworkService {
    private let config: NetworkConfigurable
    
    init(config: NetworkConfigurable) {
        self.config = config
    }
    
    func request<T: Decodable>(endPoint: Requestable, type: T.Type) -> AnyPublisher<T?, NetworkError> {
        return Future<T?, NetworkError> { promise in
            guard let request = endPoint.urlRequest(with: self.config) else {
                promise(.failure(NetworkError.error(message: "Invalid url")))
                return
            }
            request.validate()
            request.responseDecodable(of: T.self) { response in
                print("request: \(response.request!.url!.absoluteString)")
                switch response.result {
                    case .success(let res):
                    promise(.success(res))

                    case .failure(let error):
                    print("failure")
                    promise(.failure(NetworkError.error(message: error.localizedDescription)))
                }
                            
            }
        }.eraseToAnyPublisher()
    }
}
