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



