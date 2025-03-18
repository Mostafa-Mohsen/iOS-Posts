//
//  ListLoadingView.swift
//  Posts
//
//  Created by M-M-M on 18/03/2025.
//

import SwiftUI

struct ListLoadingView: View {
    @State var show: Bool = false
    var body: some View {
        HStack {
            Spacer()
            if show {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.5)
            }
            Spacer()
        }
        .frame(height: 40)
        .onAppear {
            show = true
        }
        .onDisappear {
            show = false
        }
    }
}

struct ListLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ListLoadingView()
    }
}
