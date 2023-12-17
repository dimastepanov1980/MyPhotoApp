//
//  CustomerMainCellView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI

struct CustomerMainCellView: View {
    var items: AuthorPortfolioModel
    @State private var currentStep = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            TabView(selection: $currentStep) {
                ForEach(items.smallImagesPortfolio.indices, id: \.self) { index in
                    AsyncImageView(imagePath: items.smallImagesPortfolio[index])
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            .mask {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 300)
                
            }
            .padding(.horizontal, 12)
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    Text("\(currentStep + 1) / \(items.smallImagesPortfolio.count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.bottom, 12)
                        .padding(.trailing, 36)
                }
            }
            
            HStack{
                VStack(alignment: .leading){
                    if let author = items.author {
                        Text("\(author.nameAuthor) \(author.familynameAuthor)")
                            .font(.headline.bold())
                            .foregroundColor(Color(R.color.gray1.name))
                        Text("\(author.location)")
                            .font(.callout)
                            .foregroundColor(Color(R.color.gray4.name))
                        
                    }
                }
                .padding(.leading, 24)
                    Spacer()
                if let author = items.author, !calculateMinPrice(prices: items.appointmen).isEmpty {
                    VStack(alignment: .trailing){
                        Text(R.string.localizable.price_start())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray4.name))
                        Text("\(calculateMinPrice(prices: items.appointmen)) \(currencySymbol(for: author.regionAuthor))")
                            .font(.headline.bold())
                            .foregroundColor(Color(R.color.gray2.name))
                    }
                    .padding(.trailing, 36)
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
                } else {
                    ZStack{
                        Color(R.color.gray6.name)
                        ProgressView()
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
            // Assume you have a StorageManager.shared.getImageURL method
            try await StorageManager.shared.getImageURL(path: imagePath)
        }
    }
    private func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
    private func calculateMinPrice(prices: [DbSchedule]) -> String {
          let priceValues = prices.compactMap { Int($0.price) }
        if let minPrice = priceValues.min() {
            return "\(minPrice)"
        } else {
            return ""
        }
    }
}

struct CustomerMainCellView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    
    static var previews: some View {
        CustomerMainCellView(items: mockModel.mocData)
    }
}
private class MockViewModel: ObservableObject {
    let mocData = AuthorPortfolioModel(portfolio: DBPortfolioModel(id: UUID().uuidString,
                                                                   author:
                                                        DBAuthor(rateAuthor: 0.0,
                                                                   likedAuthor: true,
                                                                   typeAuthor: "photo",
                                                                   nameAuthor: "Test",
                                                                   familynameAuthor: "Author",
                                                                   sexAuthor: "Male",
                                                                   ageAuthor: "25",
                                                                   location: "Maoi",
                                                                   latitude: 0.0,
                                                                   longitude: 0.0,
                                                                   regionAuthor: "UA",
                                                                   styleAuthor: ["Fashion", "Love Story"],
                                                                   imagesCover: ["", ""]),
                                                                   avatarAuthor: "",
                                                                   smallImagesPortfolio: ["String","String"],
                                                                   largeImagesPortfolio: ["String"],
                                                                   descriptionAuthor: "",
                                                                   schedule: [],
                                                                   bookingDays: [:]))
}
