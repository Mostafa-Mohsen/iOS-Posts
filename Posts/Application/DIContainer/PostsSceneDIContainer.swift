//
//  PostsSceneDIContainer.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation
import UIKit
import SwiftUI

final class PostsSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var userDataStorage: UserDataResponseStorage = CoreDateUserResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makePostsListUseCase() -> PostsListUseCase {
        DefaultPostsUseCase(postsRepository: makePostsListRepository())
    }
    
    
    // MARK: - Repositories
    func makePostsListRepository() -> PostsRepository {
        DefaultPostsRepository(networkService: dependencies.networkService,
                               cache: userDataStorage)
    }
    
    
    // MARK: - Posts List
    func makePostsListViewController(actions: PostsListViewModelActions) -> UIViewController {
        let view = PostsListView(
            viewModelWrapper: makePostsListViewModelWrapper(actions: actions))
        return UIHostingController(rootView: view)
    }
    
    func makePostsListViewModelWrapper(actions: PostsListViewModelActions) -> PostListViewModelWrapper {
        return PostListViewModelWrapper(viewModel: makePostsListViewModel(actions: actions))
    }
    
    func makePostsListViewModel(actions: PostsListViewModelActions) -> PostsListViewModel {
        DefaultPostsListViewModel(postsListUseCase: makePostsListUseCase(),
                                  actions: actions)
    }
    
    
}
