//
//  PostListItemView.swift
//  Posts
//
//  Created by M-M-M on 18/03/2025.
//

import SwiftUI

struct PostListItemView: View {
    var profileImage: String
    var username: String
    var postText: String
    var images: [String]
    let didClickOnImage: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // User Info
            if !username.isEmpty {
                HStack {
                    Image(profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .contentShape(Circle())
                        .onTapGesture() {
                            didClickOnImage(profileImage)
                        }
                    
                    Text(username)
                        .font(.headline)
                    
                    Spacer()
                }
            }

            // Post Text
            Text(postText)
                .font(.body)
                .foregroundColor(.black)

            // Post Images
            if !images.isEmpty {
                ImageGrid(images: images,
                          didClickOnImage: didClickOnImage)
            }
        }
    }
}

struct ImageGrid: View {
    var images: [String]
    let didClickOnImage: (String) -> Void

    var body: some View {
        switch images.count {
        case 1:
            singleImageView
        case 2:
            twoImagesView
        case 3:
            threeImagesView
        default:
            fourImagesView
        }
    }

    private var singleImageView: some View {
        Image(images[0])
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: 250)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture() {
                didClickOnImage(images[0])
            }
    }

    private var twoImagesView: some View {
        HStack(spacing: 5) {
            ForEach(images, id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width - 15)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture() {
                        didClickOnImage(image)
                    }
            }
        }
    }

    private var threeImagesView: some View {
        HStack(spacing: 5) {
            Image(images[0])
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width - 25)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture() {
                    didClickOnImage(images[0])
                }
            
            VStack(spacing: 5) {
                ForEach(images[1...2], id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 15)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture() {
                            didClickOnImage(image)
                        }
                        
                }
            }
        }
    }

    private var fourImagesView: some View {
        let gridItemSize = UIScreen.main.bounds.width / 2 - 25
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 2), spacing: 5) {
            ForEach(images[0...3], id: \.self) { image in
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: gridItemSize, height: gridItemSize)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture() {
                        didClickOnImage(image)
                    }
            }
        }
    }

}


struct PostListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PostListItemView(profileImage: "profileImage-1",
                         username: "emilyes",
                         postText: "this is a post text",
                         images: ["postImage-1"],
                         didClickOnImage: {_ in})
    }
}
