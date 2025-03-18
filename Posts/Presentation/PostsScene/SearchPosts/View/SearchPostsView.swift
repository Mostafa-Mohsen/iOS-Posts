//
//  SearchPostsView.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import SwiftUI
import Combine

struct SearchPostsView: View {
    @ObservedObject var viewModelWrapper: SearchPostsViewModelWrapper
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                List {
                    // post item
                    ForEach(viewModelWrapper.items, id: \.id) { post in
                        PostListItemView(profileImage: post.profileImage,
                                         username: post.fullName,
                                         postText: post.body,
                                         images: post.postImages,
                                         didClickOnImage: didClickOnImage)
                    }
                    
                    // list loading view
                    if viewModelWrapper.showListLoader  {
                        ListLoadingView()
                            .onAppear() {
                                viewModelWrapper.viewModel?.loadNextPage()
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            // empty results
            if viewModelWrapper.isEmptyResults {
                Text(viewModelWrapper.viewModel?.emptyResultsMessage ?? "")
            }
            
            // loading view
            if viewModelWrapper.showPageLoader {
                FullScreenLoadingView()
            }
        }
        .searchable(text: $viewModelWrapper.searchQuery)
        .onSubmit(of: .search) {
            viewModelWrapper.viewModel?.didSearch(query: viewModelWrapper.searchQuery)
        }
        .alert(isPresented: $viewModelWrapper.showAlert) {
            Alert(
                title: Text(viewModelWrapper.viewModel?.errorTitle ?? ""),
                message: Text(viewModelWrapper.alertMessage),
                dismissButton: .default(Text(viewModelWrapper.viewModel?.errorDismissText ?? ""))
            )
        }
        .navigationTitle(viewModelWrapper.viewModel?.screenTitle ?? "")
    }
    
    private func didClickOnImage(_ image: String) {
        viewModelWrapper.viewModel?.didClickOn(image: image)
    }
}

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

struct SearchPostsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPostsView(viewModelWrapper: SearchPostsViewModelWrapper(viewModel: nil))
    }
}
