//
//  SearchPostsViewModel.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import Combine



enum SearchPostsViewModelLoading {
    case fullScreen
    case nextPage
    case none
}

protocol SearchPostsViewModelInput {
    func loadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func didClickOn(image: String)
}


