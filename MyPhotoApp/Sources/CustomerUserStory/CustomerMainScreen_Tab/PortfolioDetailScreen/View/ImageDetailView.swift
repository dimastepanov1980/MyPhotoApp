//
//  ImageDetailView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import SwiftUI

struct ImageDetailView: View {
    let imagePath: String
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            AsyncImageView(imagePath: imagePath)
        }
    }
    
    private struct AsyncImageView: View {
        let imagePath: String
        @State private var imageURL: URL?
        @State private var image: UIImage? // New state to hold the image
        
        var body: some View {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                       
                } else {
                    ProgressView()
                }
            }
            
            .onAppear {
                // Fetch the image URL and download the image concurrently
                Task {
                    do {
                        let url = try await imagePathToURL(imagePath: imagePath)
                        imageURL = url
                        
                        // Download the image using the URL
                        let (imageData, _) = try await URLSession.shared.data(from: url)
                        image = UIImage(data: imageData)
                    } catch {
                        // Handle errors
                        print("Error fetching image URL or downloading image: \(error)")
                    }
                }
            }
        }
        
        private func imagePathToURL(imagePath: String) async throws -> URL {
            // Assume you have a StorageManager.shared.getImageURL method
            try await StorageManager.shared.getImageURL(path: imagePath)
        }
    }

}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(imagePath:"")
    }
}
