//
//  FetchPostsUseCaseTest.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import XCTest
import Combine
@testable import Posts

class FetchPostsUseCaseTest: XCTestCase {
    var postsRepository: PostsRepositoryMock!
    var useCase: DefaultPostsUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let networkServiceMock = NetworkServiceMock()
        let cacheMock = UserDataResponseStorageMock()
        postsRepository = PostsRepositoryMock(network: networkServiceMock,
                                              cache: cacheMock)
        useCase = DefaultPostsUseCase(postsRepository: postsRepository)
        cancellables = []
    }
    
    override func tearDown() {
        postsRepository = nil
        useCase = nil
        cancellables = nil
    }
    
    func test_whenFetchPostsUseCaseFetchPosts_thenSucceedToRecieveData() {
        //given
        postsRepository.shouldFailToFetch = false
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        //when
        let request = PostsUseCaseRequestValue(limit: 4, skip: 0)
        useCase.execute(requestValue: request)
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
    
    func test_whenFetchPostsUseCaseFetchPosts_thenFailToRecieveData() {
        //given
        postsRepository.shouldFailToFetch = true
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        //when
        let request = PostsUseCaseRequestValue(limit: 4, skip: 0)
        useCase.execute(requestValue: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        //then
                        XCTAssertEqual(message, "failed to load data")
                    }
                    expectation.fulfill()
                }
                
            }, receiveValue: { _ in})
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenFetchUserDataUseCaseFetchUsers_thenSucceedToRecieveData() {
        //given
        postsRepository.shouldFailToFetch = false
        let expectation = XCTestExpectation(description: "Fetch users")
        
        //when
        let request = FetchUsersUseCaseRequestValue(ids: [1])
        useCase.execute(requestValue: request)
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
            })
            .store(in: &self.cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_whenFetchUserDataUseCaseFetchUsers_thenFailToRecieveData() {
        //given
        postsRepository.shouldFailToFetch = true
        let expectation = XCTestExpectation(description: "Fetch users")
        
        //when
        let request = FetchUsersUseCaseRequestValue(ids: [1])
        useCase.execute(requestValue: request)
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
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
