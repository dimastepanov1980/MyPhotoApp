//
//  PortfolioDetailScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/31/23.
//

import SwiftUI

struct PortfolioDetailScreenView: View {
    var images: [String]
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath

    var body: some View {
        VStack{
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 0),
                                        GridItem(.flexible(), spacing: 0)], spacing: 0){
                        ForEach(images.indices, id: \.self) { index in
                            NavigationLink {
                                ImageDetailView(imagePath: images[index])
                            } label: {
                                AsyncImageView(imagePath: images[index])
                            }
                        }
                    }

                }
        }
        .onAppear{
            print("myPathCount\(path.count)")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
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
    private var customBackButton : some View {
        Button {
            dismiss()
        } label: {
            HStack{
                Image(systemName: "chevron.left.circle.fill")// set image here
                    .font(.title)
                    .foregroundStyle(.white, Color(R.color.gray1.name).opacity(0.7))
           
            }
        }
    }


}

struct PortfolioDetailScreenView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()

    static var previews: some View {
        NavigationStack{
            PortfolioDetailScreenView(images: viewModel.images, path: .constant(NavigationPath()))
        }
    }
}
private class MockViewModel: ObservableObject, PortfolioDetailScreenViewModelType {
    @Published var images: [String] = ["String","String","String", "String", "String", "String", "String"]
}
