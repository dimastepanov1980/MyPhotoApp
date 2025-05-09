//
//  ImageDetailView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import SwiftUI

struct ImageDetailViewPath: View {
    let imagePath: String
    @EnvironmentObject var router: Router<Views>

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            AsyncImageView(imagePath: imagePath)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView())
    }
    
    private struct AsyncImageView: View {
        let imagePath: String
        @State private var imageURL: URL?
        @State private var image: UIImage?
        
        var body: some View {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                       
                } else {
                    ZStack{
                        ProgressView()
                            .tint(Color.white)
                    }
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
            try await StorageManager.shared.getImageURL(path: imagePath)
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailViewPath(imagePath:"")
    }
}
