//
//  PostsRepositoryMock.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import Combine
@testable import Posts

class PostsRepositoryMock: PostsRepository {
    var networkService: NetworkService { return networkMock }
    var cache: UserDataResponseStorage { return cacheMock }
    var networkMock: NetworkServiceMock!
    var cacheMock: UserDataResponseStorageMock!
    var shouldFailToFetch = false
    var fetchUserRemote = true
    
    init(network: NetworkServiceMock, cache: UserDataResponseStorageMock) {
        self.networkMock = network
        self.cacheMock = cache
    }
    
    func getPosts(limit: Int, skip: Int) -> AnyPublisher<PostsPage?, NetworkError> {
        if shouldFailToFetch {
            networkMock.response = nil
        } else {
            networkMock.response = PostsResponseDTO(posts: [
                PostsResponseDTO.PostDTO(id: 1, body: "body-1", userId: 1)
            ], skip: skip, limit: limit, total: 1)
        }
        let request = PostsRequestDTO(limit: 4, skip: 0)
        let endPoint = APIEndpoints.getPosts(with: request)
        return networkService.request(endPoint: endPoint, type: PostsResponseDTO.self)
            .map { postPage in return postPage?.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getUsersBy(ids: [Int]) -> AnyPublisher<[UserData?], Never> {
        if fetchUserRemote {
            return getRemoteUsers(ids: ids)
        } else {
            return getLocalUsers(ids: ids)
        }
    }
    
    private func getLocalUsers(ids: [Int]) -> AnyPublisher<[UserData?], Never> {
        let request = FetchUserDataRequestDTO(id: ids[0])
        if !shouldFailToFetch {
            let cachedResponse = FetchUserDataResponseDTO(id: 1, firstName: "cachedFirstName-1", lastName: "cachedLastName-1")
            cache.save(response: cachedResponse, for: request)
        }
        return cache.getResponse(for: request)
            .map { userData in [userData?.toDomain()] }
            .replaceError(with: [nil])
            .eraseToAnyPublisher()
    }
    
    private func getRemoteUsers(ids: [Int]) -> AnyPublisher<[UserData?], Never> {
        let request = FetchUserDataRequestDTO(id: ids[0])
        let endPoint = APIEndpoints.getUserData(with: request)
        if !shouldFailToFetch {
            networkMock.response = FetchUserDataResponseDTO(id: 1, firstName: "remoteFirstName-1", lastName: "remoteLastName-1")
        }
        return networkService.request(endPoint: endPoint, type: FetchUserDataResponseDTO.self)
            .map { userData in
                return [userData?.toDomain()] }
            .replaceError(with: [nil])
            .eraseToAnyPublisher()
    }
}
