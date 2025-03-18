//
//  SearchPostsViewModel.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation
import Combine

struct SearchPostsViewModelActions {
    let closeSearchPosts: () -> Void
    let showImagePreview: (String) -> Void
}

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

protocol SearchPostsViewModelOutput {
    var items: CurrentValueSubject<[PostsListItemViewModel], Never> { get }
    var loading: CurrentValueSubject<SearchPostsViewModelLoading, Never> { get }
    var showListLoader: PassthroughSubject<Bool, Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    var isEmptyResults: PassthroughSubject<Bool, Never> { get }
    var screenTitle: String { get }
    var emptyResultsMessage: String { get }
    var errorTitle: String { get }
    var errorDismissText: String { get }
}

