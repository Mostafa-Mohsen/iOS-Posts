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
    
    func makeSearchPostsUseCase() -> SearchPostsUseCase {
        DefaultSearchPostsUseCase(searchPostsRepository: makeSearchPostsRepository())
    }
    
    // MARK: - Repositories
    func makePostsListRepository() -> PostsRepository {
        DefaultPostsRepository(networkService: dependencies.networkService,
                               cache: userDataStorage)
    }
    
    func makeSearchPostsRepository() -> SearchPostsRepository {
        DefaultSearchPostsRepository(networkService: dependencies.networkService,
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
    
    // MARK: - Search Posts
    func makeSearchPostsViewController(actions: SearchPostsViewModelActions) -> UIViewController {
        let view = SearchPostsView(
            viewModelWrapper: makeSearchPostsViewModelWrapper(actions: actions))
        return UIHostingController(rootView: view)
    }
    
    func makeSearchPostsViewModelWrapper(actions: SearchPostsViewModelActions) -> SearchPostsViewModelWrapper {
        return SearchPostsViewModelWrapper(viewModel: makeSearchPostsViewModel(actions: actions))
    }
    
    func makeSearchPostsViewModel(actions: SearchPostsViewModelActions) -> SearchPostsViewModel {
        DefaultSearchPostsViewModel(searchPostsUseCase: makeSearchPostsUseCase(),
                                  actions: actions)
    }
    
    // MARK: - Image Preview
    func makeImagePreviewViewController(image: String, actions: ImagePreviewViewModelActions) -> UIViewController {
        let view = ImagePreviewView(
            viewModelWrapper: makeImagePreviewViewModelWrapper(image: image,
                                                               actions: actions))
        return UIHostingController(rootView: view)
    }
    
    func makeImagePreviewViewModelWrapper(image: String, actions: ImagePreviewViewModelActions) -> ImagePreviewViewModelWrapper {
        return ImagePreviewViewModelWrapper(viewModel: makeImagePreviewViewModel(image: image,
                                                                                 actions: actions))
    }
    
    func makeImagePreviewViewModel(image: String, actions: ImagePreviewViewModelActions) -> ImagePreviewViewModel {
        DefaultImagePreviewViewModel(actions: actions,
                                     image: image)
    }
    
    // MARK: - Flow Coordinators
    func makePostsFlowCoordinator(navigationController: UINavigationController) -> PostsFlowCoordinator {
        PostsFlowCoordinator(navigationController: navigationController,
                             dependencies: self)
    }
}

extension PostsSceneDIContainer: PostsFlowCoordinatorDependencies {
    
}
