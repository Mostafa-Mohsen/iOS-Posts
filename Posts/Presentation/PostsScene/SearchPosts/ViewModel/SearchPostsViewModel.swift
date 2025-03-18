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

typealias SearchPostsViewModel = SearchPostsViewModelInput & SearchPostsViewModelOutput

final class DefaultSearchPostsViewModel: SearchPostsViewModelOutput {

    private let searchPostsUseCase: SearchPostsUseCase
    private let actions: SearchPostsViewModelActions?

    private var query: String = ""
    private var skip: Int = 0
    private var totalCount: Int = 0
    private var limit: Int = 4
    private var hasMorePages: Bool { totalCount > skip }
    private var posts: [Post] = []
    private var cancellable: [AnyCancellable] = []
    
    
    // MARK: - OUTPUT
    let items = CurrentValueSubject<[PostsListItemViewModel], Never>([])
    let loading = CurrentValueSubject<SearchPostsViewModelLoading, Never>(.none)
    var showListLoader = PassthroughSubject<Bool, Never>()
    let error = PassthroughSubject<String, Never>()
    var isEmptyResults = PassthroughSubject<Bool, Never>()
    let screenTitle = "Search"
    let emptyResultsMessage = "No Result Found"
    let errorTitle = "Error"
    var errorDismissText = "Ok"

    // MARK: - Init
    init(searchPostsUseCase: SearchPostsUseCase,
        actions: SearchPostsViewModelActions? = nil) {
        self.searchPostsUseCase = searchPostsUseCase
        self.actions = actions
    }

    
}

// MARK: - INPUT. View event methods
extension DefaultSearchPostsViewModel: SearchPostsViewModelInput {
    func didSearch(query: String) {
        
    }
    
    func loadNextPage() {
        
    }
    
    func didCancelSearch() {
        
    }
    
    func didClickOn(image: String) {
        
    }
}
