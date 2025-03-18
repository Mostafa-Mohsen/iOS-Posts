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


