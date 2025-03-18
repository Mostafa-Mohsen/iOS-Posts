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
       
    }
    
    
    private func showImagePreview(image: String) {
        
    }
}

