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


