//
//  SearchPostsView.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import SwiftUI
import Combine



final class SearchPostsViewModelWrapper: ObservableObject {
    var viewModel: SearchPostsViewModel?
    @Published var items: [PostsListItemViewModel] = []
    @Published var searchQuery: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showPageLoader: Bool = false
    @Published var showListLoader: Bool = false
    @Published var isEmptyResults: Bool = false
    
    private var cancellable: [AnyCancellable] = []
    
    init(viewModel: SearchPostsViewModel?) {
        self.viewModel = viewModel
        self.viewModel?.items.sink {
            self.items = $0
        }
        .store(in: &cancellable)
        self.viewModel?.loading.sink {
            self.showPageLoader = $0 == .fullScreen
        }
        .store(in: &cancellable)
        self.viewModel?.showListLoader.sink {
            self.showListLoader = $0
        }
        .store(in: &cancellable)
        self.viewModel?.error.sink {
            self.alertMessage = $0
            self.showAlert = true
        }
        .store(in: &cancellable)
        self.viewModel?.isEmptyResults.sink {
            self.isEmptyResults = $0
        }
        .store(in: &cancellable)
    }
}
