//
//  SearchPostsViewModel.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import Combine



protocol SearchPostsViewModelInput {
    func loadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func didClickOn(image: String)
}


