//
//  ImagePreviewViewModel.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation

struct ImagePreviewViewModelActions {
    let closeImagePreview: () -> Void
}

protocol ImagePreviewViewModelInput {
    func didClickCloseImagePreview()
}

protocol ImagePreviewViewModelOutput {
    var screenTitle: String { get }
    var image: String { get }
}

typealias ImagePreviewViewModel = ImagePreviewViewModelInput & ImagePreviewViewModelOutput

final class DefaultImagePreviewViewModel: ImagePreviewViewModelOutput {
    private let actions: ImagePreviewViewModelActions?
    
    // MARK: - OUTPUT
    let screenTitle: String = "Image Preview"
    let image: String
    
    init(actions: ImagePreviewViewModelActions?,
        image: String) {
        self.actions = actions
        self.image = image
    }
}

// MARK: - INPUT. View event methods
extension DefaultImagePreviewViewModel: ImagePreviewViewModelInput {
    func didClickCloseImagePreview() {
        actions?.closeImagePreview()
    }
}
