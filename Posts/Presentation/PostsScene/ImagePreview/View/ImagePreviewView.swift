//
//  ImagePreviewView.swift
//  Posts
//
//  Created by M-M-M on 16/03/2025.
//

import SwiftUI

struct ImagePreviewView: View {
    @ObservedObject var viewModelWrapper: ImagePreviewViewModelWrapper
    
    var body: some View {
        ZStack {
            Image(viewModelWrapper.viewModel?.image ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(viewModelWrapper.zoomState)
                .gesture(MagnificationGesture()
                    .onChanged({ value in
                        viewModelWrapper.zoomState = value.magnitude
                    })
                )
            HStack {
                Spacer()
                VStack {
                    Button("❌") {
                        viewModelWrapper.viewModel?.didClickCloseImagePreview()
                    }
                    .frame(width: 50, height: 50)
                    
                    Spacer()
                }
            }
        }
    }
}

final class ImagePreviewViewModelWrapper: ObservableObject {
    var viewModel: ImagePreviewViewModel?
    @Published var zoomState: CGFloat = 1
    
    init(viewModel: ImagePreviewViewModel?) {
        self.viewModel = viewModel
    }
}

struct ImagePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreviewView(viewModelWrapper: ImagePreviewViewModelWrapper(viewModel: nil))
    }
}
