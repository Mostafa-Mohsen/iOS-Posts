//
//  PostsListView.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import SwiftUI
import Combine

struct PostsListView: View {
    @ObservedObject var viewModelWrapper: PostListViewModelWrapper
    
    var body: some View {
        ZStack {
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
            
            // loading view
            if viewModelWrapper.showPageLoader {
                FullScreenLoadingView()
            }
        }
        .alert(isPresented: $viewModelWrapper.showAlert) {
            Alert(
                title: Text(viewModelWrapper.viewModel?.errorTitle ?? ""),
                message: Text(viewModelWrapper.alertMessage),
                dismissButton: .default(Text(viewModelWrapper.viewModel?.errorDismissText ?? ""))
            )
        }
        .toolbar {
            Button(action: {
                viewModelWrapper.viewModel?.didClickSearch()
            }, label: {
                Image(systemName: viewModelWrapper.viewModel?.searchIcon ?? "")
                    .foregroundColor(.gray)
            })
        }
        .onAppear() {
            viewModelWrapper.viewModel?.viewDidLoad()
        }
        .navigationTitle(viewModelWrapper.viewModel?.screenTitle ?? "")
        .navigationBarHidden(false)
    }
    
    private func didClickOnImage(_ image: String) {
        viewModelWrapper.viewModel?.didClickOn(image: image)
    }
}

final class PostListViewModelWrapper: ObservableObject {
    var viewModel: PostsListViewModel?
    @Published var items: [PostsListItemViewModel] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showPageLoader: Bool = false
    @Published var showListLoader: Bool = false
    private var cancellable: [AnyCancellable] = []
    
    init(viewModel: PostsListViewModel?) {
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
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView(viewModelWrapper: PostListViewModelWrapper(viewModel: nil))
    }
}
