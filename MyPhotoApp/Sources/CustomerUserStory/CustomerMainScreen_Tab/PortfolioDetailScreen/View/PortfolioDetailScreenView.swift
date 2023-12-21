//
//  PortfolioDetailScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import SwiftUI

struct PortfolioDetailScreenView: View {
    var images: [String]
    @EnvironmentObject var router: Router<Views>

    var body: some View {
        VStack{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 0),
                                        GridItem(.flexible(), spacing: 0)], spacing: 0){
                        ForEach(images.indices, id: \.self) { index in
                                AsyncImageView(imagePath: images[index])
                                .onTapGesture {
                                    router.push(.ImageDetailView(image: images[index]))
                                }
                        }
                    }   
                }
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
            PortfolioDetailScreenView(images: viewModel.images)
    
    }
}
private class MockViewModel: ObservableObject, PortfolioDetailScreenViewModelType {
    @Published var images: [String] = ["String","String","String", "String", "String", "String", "String"]
}
