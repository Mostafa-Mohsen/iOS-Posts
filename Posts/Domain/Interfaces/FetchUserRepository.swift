//
//  FetchUserRepository.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import Combine

protocol FetchUserRepository {
    var networkService: NetworkService { get }
    var cache: UserDataResponseStorage { get }
    func getUsersBy(ids: [Int]) -> AnyPublisher<[UserData?], Never>
}

extension FetchUserRepository {
    func getUsersBy(ids: [Int]) -> AnyPublisher<[UserData?], Never> {
        return getCachedUsers(ids: ids)
            .flatMap { cachedUsers in
                let unwrappedCachedUsers = cachedUsers.compactMap({ $0 })
                let cachedIds = unwrappedCachedUsers.map{ $0.id }
                let remainingIds = ids.filter({ !cachedIds.contains($0) })
                return getRemoteUsersBy(ids: remainingIds)
                    .map { remoteUsers in
                        return unwrappedCachedUsers + remoteUsers
                    }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func getRemoteUsersBy(ids: [Int]) -> AnyPublisher<[UserData?], Never> {
        let publishers = ids.map { getRemoteUser(id: $0) }
        return Publishers.MergeMany(publishers)
                .collect()
                .eraseToAnyPublisher()
    }
    
    private func getRemoteUser(id: Int) -> AnyPublisher<UserData?, Never> {
        let requestDTO = FetchUserDataRequestDTO(id: id)
        let endpoint = APIEndpoints.getUserData(with: requestDTO)
        
        return networkService.request(endPoint: endpoint, type: FetchUserDataResponseDTO.self)
            .map{ (postsResponse) -> UserData? in
                guard let unwrappedPosts = postsResponse else { return nil }
                cache.save(response: unwrappedPosts, for: requestDTO)
                return unwrappedPosts.toDomain()
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func getCachedUsers(ids: [Int]) -> AnyPublisher<[UserData?], Never> {
        let publishers = ids.map { getCachedUser(id: $0) }
        return Publishers.MergeMany(publishers)
                .collect()
                .eraseToAnyPublisher()
    }
    
    private func getCachedUser(id: Int) -> AnyPublisher<UserData?, Never> {
        let requestDTO = FetchUserDataRequestDTO(id: id)
        
        return cache.getResponse(for: requestDTO)
            .map{ (postsResponse) -> UserData? in
                guard let unwrappedPosts = postsResponse else { return nil }
                return unwrappedPosts.toDomain()
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
