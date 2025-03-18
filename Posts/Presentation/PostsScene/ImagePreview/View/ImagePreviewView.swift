//
//  ImagePreviewView.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import SwiftUI



final class ImagePreviewViewModelWrapper: ObservableObject {
    var viewModel: ImagePreviewViewModel?
    @Published var zoomState: CGFloat = 1
    
    init(viewModel: ImagePreviewViewModel?) {
        self.viewModel = viewModel
    }
}


