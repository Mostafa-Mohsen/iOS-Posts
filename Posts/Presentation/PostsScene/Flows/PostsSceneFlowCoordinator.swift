//
//  PostsSceneFlowCoordinator.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation
import UIKit

protocol PostsFlowCoordinatorDependencies  {
    func makePostsListViewController(actions: PostsListViewModelActions) -> UIViewController
    func makeSearchPostsViewController(actions: SearchPostsViewModelActions) -> UIViewController
    func makeImagePreviewViewController(image: String, actions: ImagePreviewViewModelActions) -> UIViewController
}

final class PostsFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: PostsFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: PostsFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = PostsListViewModelActions(showSearchPosts: showSearchPosts,
                                                showImagePreview: showImagePreview)
        let vc = dependencies.makePostsListViewController(actions: actions)
        navigationController?.viewControllers = [vc]
    }
    
    private func showSearchPosts() {
        let actions = SearchPostsViewModelActions(showImagePreview: showImagePreview)
        let vc = dependencies.makeSearchPostsViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func showImagePreview(image: String) {
        let actions = ImagePreviewViewModelActions(closeImagePreview: closeImagePreview)
        let vc = dependencies.makeImagePreviewViewController(image: image, actions: actions)
        navigationController?.present(vc, animated: true)
    }
    
    private func closeImagePreview() {
    }
}

