//
//  ImagePreviewViewModel.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import Foundation



protocol ImagePreviewViewModelInput {
    func didClickCloseImagePreview()
}

protocol ImagePreviewViewModelOutput {
    var screenTitle: String { get }
    var image: String { get }
}


