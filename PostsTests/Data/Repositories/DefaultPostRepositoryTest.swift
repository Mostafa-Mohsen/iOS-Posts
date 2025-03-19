//
//  DefaultPostRepositoryTest.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import XCTest
import Combine
@testable import Posts

class DefaultPostRepositoryTest: XCTestCase {
    var networkMock: NetworkServiceMock!
    var cacheMock: UserDataResponseStorageMock!
    var repository: DefaultPostsRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        networkMock = NetworkServiceMock()
        cacheMock = UserDataResponseStorageMock()
        repository = DefaultPostsRepository(networkService: networkMock,
                                            cache: cacheMock)
        cancellables = []
    }
    
    override func tearDown() {
        networkMock = nil
        cacheMock = nil
        repository = nil
        cancellables = nil
    }
    
    func test_whenDefaultPostsRepositoryFetchPosts_thenSucceedToRecieveData() {
        //given
        let expectation = XCTestExpectation(description: "Fetch posts")
        networkMock.response = PostsResponseDTO(posts: [
            PostsResponseDTO.PostDTO(id: 1, body: "body-1", userId: 1)
        ], skip: 0, limit: 4, total: 1)
        
        //when
        repository.getPosts(limit: 4, skip: 0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { posPaget in
                //then
                XCTAssertEqual(posPaget?.posts.count, 1)
                XCTAssertEqual(posPaget?.posts[0].id, 1)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenDefaultPostsRepositoryFetchPosts_thenFailToRecieveData() {
        //given
        let expectation = XCTestExpectation(description: "Fetch posts")
        //when
        repository.getPosts(limit: 4, skip: 0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(_):
                    //then
                    expectation.fulfill()
                }
            }, receiveValue: {_ in})
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenDefaultPostsRepositoryFetchRemoteUsers_thenSucceedToRecieveData() {
        //given
        let expectation = XCTestExpectation(description: "Fetch users")
        networkMock.response = FetchUserDataResponseDTO(id: 1, firstName: "remoteFirstName-1", lastName: "remoteLastName-1")
        //when
        repository.getUsersBy(ids: [1])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { usersData in
                //then
                XCTAssertEqual(usersData.count, 1)
                XCTAssertEqual(usersData[0]?.id, 1)
                XCTAssertEqual(usersData[0]?.firstName, "remoteFirstName-1")
                XCTAssertEqual(usersData[0]?.lastName, "remoteLastName-1")
            })
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenDefaultPostsRepositoryFetchCachedUsers_thenSucceedToRecieveData() {
        //given
        let expectation = XCTestExpectation(description: "Fetch users")
        let request = FetchUserDataRequestDTO(id: 1)
        let cachedResponse = FetchUserDataResponseDTO(id: 1, firstName: "cachedFirstName-1", lastName: "cachedLastName-1")
        cacheMock.save(response: cachedResponse, for: request)
        //when
        repository.getUsersBy(ids: [1])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { usersData in
                //then
                XCTAssertEqual(usersData.count, 1)
                XCTAssertEqual(usersData[0]?.id, 1)
                XCTAssertEqual(usersData[0]?.firstName, "cachedFirstName-1")
                XCTAssertEqual(usersData[0]?.lastName, "cachedLastName-1")
            })
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenDefaultPostsRepositoryFetchUsers_thenFailToRecieveData() {
        //given
        let expectation = XCTestExpectation(description: "Fetch users")
        //when
        repository.getUsersBy(ids: [1])
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { usersData in
                //then
                let compactUserData = usersData.compactMap({ $0 })
                XCTAssertEqual(compactUserData.count, 0)
            })
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
}
