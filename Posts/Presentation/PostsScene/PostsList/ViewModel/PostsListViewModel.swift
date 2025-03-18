//
//  PostsListViewModel.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation
import Combine



enum PostsListViewModelLoading {
    case fullScreen
    case nextPage
    case none
}

protocol PostsListViewModelInput {
    func viewDidLoad()
    func loadNextPage()
    func didClickSearch()
    func didClickOn(image: String)
}


