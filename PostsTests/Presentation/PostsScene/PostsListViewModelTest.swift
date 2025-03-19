//
//  PostsListViewModelTest.swift
//  PostsTests
//
//  Created by M-M-M on 20/03/2025.
//

import Foundation
import XCTest
import Combine
@testable import Posts

class PostsListViewModelTest: XCTestCase {
    var mockUseCase: PostsListUseCaseMock!
    var viewModel: DefaultPostsListViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let networkServiceMock = NetworkServiceMock()
        let cacheMock = UserDataResponseStorageMock()
        let postsRepository = PostsRepositoryMock(network: networkServiceMock,
                                                  cache: cacheMock)
        mockUseCase = PostsListUseCaseMock(mockRepository: postsRepository)
        viewModel = DefaultPostsListViewModel(postsListUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
    }
    
    func test_whenPostsListUseCaseFetchFirstPage_thenSucceedToRecieveData() {
        //given
        mockUseCase.shouldFailToFetch = false
        let expectation = XCTestExpectation(description: "Fetch posts and users")
        //when
        viewModel.viewDidLoad()
        viewModel.items.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }, receiveValue: { items in
            //then
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items[0].id, 1)
            XCTAssertEqual(items[0].firstName, "remoteFirstName-1")
        })
        .store(in: &cancellables)
    }
    
    func test_whenPostsListUseCaseFetchFirstPage_thenFailToRecieveData() {
        mockUseCase.shouldFailToFetch = true
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        viewModel.viewDidLoad()
        viewModel.error.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
            
        }, receiveValue: { error in
            XCTAssertEqual(error, "failed to load data")
        })
        .store(in: &cancellables)
    }
}
