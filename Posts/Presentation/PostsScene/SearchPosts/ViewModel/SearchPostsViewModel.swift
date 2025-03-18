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

    // MARK: - Private
    private func appendPage(postsPage: PostsPage, usersData: [Int: UserDataViewModel]) {
        totalCount = postsPage.total
        posts += postsPage.posts
        skip = posts.count
        let viewModelItems = postsPage.posts.map{ PostsListItemViewModel(post: $0, user: usersData[$0.userId ?? -1]) }
        items.send(items.value + viewModelItems)
        showListLoader.send(hasMorePages)
        loading.send(.none)
        if posts.isEmpty { isEmptyResults.send(true) }
    }

    private func resetPages() {
        query = ""
        skip = 0
        totalCount = 0
        showListLoader.send(false)
        posts.removeAll()
        items.send([])
        loading.send(.none)
        isEmptyResults.send(false)
    }

    private func loadPosts(with query: String, loading: SearchPostsViewModelLoading) {
        self.loading.send(loading)
        
        searchPostsUseCase.execute(requestValue: .init(limit: limit, skip: skip, query: query))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("All publishers completed successfully.")
                case .failure(let error):
                    self.loading.send(.none)
                    
                }
            },
            receiveValue: { postsPage in
                guard let unwrappedPostsPage = postsPage else { return }
                self.loadUsersFor(postPage: unwrappedPostsPage)
            })
            .store(in: &cancellable)
    }
    
    private func loadUsersFor(postPage: PostsPage) {
        let ids = postPage.posts.compactMap{ $0.userId }
        searchPostsUseCase.execute(requestValue: .init(ids: ids))
            .sink() { usersData in
                var usersDict = [Int: UserDataViewModel]()
                usersData.compactMap { $0 }
                    .forEach({
                        usersDict[$0.id] = UserDataViewModel(firstName: $0.firstName, lastName: $0.lastName) })
                self.appendPage(postsPage: postPage, usersData: usersDict)
            }
            .store(in: &cancellable)
    }

    

    private func update(query: String) {
        resetPages()
        self.query = query
        loadPosts(with: query, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods
extension DefaultSearchPostsViewModel: SearchPostsViewModelInput {
    func didSearch(query: String) {
        guard !query.isEmpty, query != self.query else { return }
        update(query: query)
    }
    
    func loadNextPage() {
        guard hasMorePages, loading.value == .none, !query.isEmpty else { return }
        loadPosts(with: query, loading: .nextPage)
    }
    
    func didCancelSearch() {
        
    }
    
    func didClickOn(image: String) {
        
    }
}
