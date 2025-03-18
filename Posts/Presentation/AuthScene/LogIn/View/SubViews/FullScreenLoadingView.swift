//
//  FullScreenLoadingView.swift
//  Posts
//
//  Created by M-M-M on 18/03/2025.
//

import SwiftUI

struct FullScreenLoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}

struct FullScreenLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenLoadingView()
    }
}
