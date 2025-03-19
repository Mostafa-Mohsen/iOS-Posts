//
//  NetworkServiceMock.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import Combine
@testable import Posts

class NetworkServiceMock: NetworkService {
    var response: Any?
    func request<T>(endPoint: any Posts.Requestable, type: T.Type) -> AnyPublisher<T?, Posts.NetworkError> where T : Decodable {
        if let response = response as? T {
            return Just(response)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.error(message: "failed to load data"))
                .eraseToAnyPublisher()
        }
    }
}
