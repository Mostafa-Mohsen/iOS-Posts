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

}

// MARK: - INPUT. View event methods
extension DefaultPostsListViewModel: PostsListViewModelInput {
    func viewDidLoad() {
      
    }

    func loadNextPage() {
        
    }
    
    func didClickSearch() {
        
    }
    
    func didClickOn(image: String) {
        
    }
}
