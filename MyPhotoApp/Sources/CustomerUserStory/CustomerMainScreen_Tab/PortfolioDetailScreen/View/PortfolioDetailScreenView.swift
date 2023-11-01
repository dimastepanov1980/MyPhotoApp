//
//  PortfolioDetailScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import SwiftUI

struct PortfolioDetailScreenView<ViewModel: PortfolioDetailScreenViewModelType>: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    
    @State private var imageGallerySize = UIScreen.main.bounds.width / 3
    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack{
            imageSection
        }
    }
    
    private var imageSection: some View {
        VStack{
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 0){
                        ForEach(viewModel.images.indices, id: \.self) { index in
                            NavigationLink {
                                ImageDetailView(imagePath: viewModel.images[index])
                            } label: {
                                AsyncImageView(imagePath: viewModel.images[index])
                            }
                        }
                    }

                }
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
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(maxHeight: 250)
                        .cornerRadius(10)
                } else {
                    ProgressView()
                }
            }
            .padding(.all, 2)
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

struct PortfolioDetailScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()

    static var previews: some View {
        NavigationStack{
            PortfolioDetailScreenView(with: viewModel)
        }
    }
}


private class MockViewModel: ObservableObject, PortfolioDetailScreenViewModelType {
    @Published var images: [String] = ["String","String","String", "String", "String", "String", "String"]
}
