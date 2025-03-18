//
//  PostsListViewModel.swift
//  Posts
//
//  Created by M-M-M on 14/03/2025.
//

import Foundation
import Combine

struct PostsListViewModelActions {
    let showSearchPosts: () -> Void
    let showImagePreview: (String) -> Void
}

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

protocol PostsListViewModelOutput {
    var items: CurrentValueSubject<[PostsListItemViewModel], Never> { get }
    var loading: CurrentValueSubject<PostsListViewModelLoading, Never> { get }
    var showListLoader: PassthroughSubject<Bool, Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
    var errorDismissText: String { get }
    var searchIcon: String { get }
}

typealias PostsListViewModel = PostsListViewModelInput & PostsListViewModelOutput

final class DefaultPostsListViewModel: PostsListViewModelOutput {

    private let postsListUseCase: PostsListUseCase
    private let actions: PostsListViewModelActions?

    private var skip: Int = 0
    private var totalCount: Int = 0
    private var limit: Int = 4
    private var hasMorePages: Bool { totalCount > skip }
    private var posts: [Post] = []
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - OUTPUT
    let items = CurrentValueSubject<[PostsListItemViewModel], Never>([])
    let loading = CurrentValueSubject<PostsListViewModelLoading, Never>(.none)
    let showListLoader = PassthroughSubject<Bool, Never>()
    let error = PassthroughSubject<String, Never>()
    let screenTitle = "Posts"
    let errorTitle = "Error"
    let errorDismissText = "Ok"
    let searchIcon = "magnifyingglass"
    

    // MARK: - Init
    init(postsListUseCase: PostsListUseCase,
        actions: PostsListViewModelActions? = nil) {
        self.postsListUseCase = postsListUseCase
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
    }

    private func loadPosts(with loading: PostsListViewModelLoading) {
        self.loading.send(loading)
        postsListUseCase.execute(requestValue: .init(limit: limit, skip: skip))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("All publishers completed successfully.")
                case .failure(let error):
                    self.loading.send(.none)
                    self.handle(error: error)
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
        postsListUseCase.execute(requestValue: .init(ids: ids))
            .sink() { usersData in
                var usersDict = [Int: UserDataViewModel]()
                usersData.compactMap { $0 }
                    .forEach({
                        usersDict[$0.id] = UserDataViewModel(firstName: $0.firstName, lastName: $0.lastName) })
                self.appendPage(postsPage: postPage, usersData: usersDict)
            }
            .store(in: &cancellable)
    }

    private func handle(error: NetworkError) {
        switch error {
        case .error(_):
            self.error.send("Failed loading Posts\nTry again later")
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultPostsListViewModel: PostsListViewModelInput {
    func viewDidLoad() {
        loadPosts(with: .fullScreen)
    }

    func loadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        loadPosts(with: .nextPage)
    }
    
    func didClickSearch() {

    }
    
    func didClickOn(image: String) {
   
    }
}
