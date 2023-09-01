//
//  CustomerMainCellView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI

struct CustomerMainCellView: View {
    var items: AuthorModel
    @State private var currentStep = 0
    
    var body: some View {
        VStack(alignment: .leading) {
                    TabView(selection: $currentStep) {
                        ForEach(items.imagesCover.indices, id: \.self) { index in
                            AsyncImage(url: stringToURL(imageString: items.imagesCover[index])){ image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 270)
                                    .cornerRadius(16, corners: .allCorners)
                                    .clipped()
                            } placeholder: {
                                ZStack{
                                    ProgressView()
                                    Color.gray.opacity(0.2)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 270)
                    .padding(.horizontal, 24)
                    .overlay(alignment: .bottomTrailing) {
                        VStack {
                            Text("\(currentStep + 1) / \(items.imagesCover.count)")
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
                            Text("\(items.nameAuthor) \(items.familynameAuthor)")
                                .font(.title2.bold())
                                .foregroundColor(Color(R.color.gray1.name))
                            Text("\(items.city), \(Locale.current.localizedString(forRegionCode: items.countryCode) ?? "")")
                                .font(.callout)
                                .foregroundColor(Color(R.color.gray4.name))

                        }
                        .padding(.leading, 36)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text(R.string.localizable.price_start())
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray4.name))
                            Text("\(items.priceAuthor)\(currencySymbol(for:items.countryCode))")
                                .font(.headline.bold())
                                .foregroundColor(Color(R.color.gray2.name))
                        }
                        .padding(.trailing, 36)
                        
                    }
                }
    }
    
    private func stringToURL(imageString: String) -> URL? {
        guard let imageURL = URL(string: imageString) else { return nil }
        return imageURL
    }
    
    private func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
}
/*
struct CustomerMainCellView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    
    static var previews: some View {
        CustomerMainCellView(items: mockModel.mocData)
    }
}
private class MockViewModel: ObservableObject {
    let mocData = AuthorModel(author: DBAuthor(id: UUID().uuidString,
                         rateAuthor: 4.32,
                         likedAuthor: true,
                         nameAuthor: "Iryna Tandanaeva",
                         countryCode: "th",
                         city: "Phuket",
                         genreAuthor: ["Love Story", "Wedding", "Portrait", "Fashion", "Aerial", "Sports", "Interior", "Advertising"],
                         imagesCover: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                         priceAuthor: "250"))
}
*/
