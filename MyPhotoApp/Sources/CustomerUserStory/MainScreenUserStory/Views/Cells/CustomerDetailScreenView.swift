//
//  CustomerDetailScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/21/23.
//

import SwiftUI

struct CustomerDetailScreenView: View {
    var items: AuthorPortfolioModel
    @State private var currentStep = 0
    
    var body: some View {
        ScrollView {
            VStack{
                slider()
                VStack{
                    sheet()
                        .offset(y: -100)
                }
            }
        }
    }
    private struct ParallaxHeader<Content: View>: View {
        @ViewBuilder var content: () -> Content
        var body: some View {
            GeometryReader { gr in
                let minY = gr.frame(in: .global).minY
                content()
                    .frame(
                        width: gr.size.width,
                        height: gr.size.height + max(minY, 0)
                    )
                    .offset(y: -minY)
            }
        }
    }
    private func stringToURL(imageString: String) -> URL? {
        guard let imageURL = URL(string: imageString) else { return nil }
        return imageURL
    }
    private func slider() -> some View {
        ParallaxHeader{
            TabView(selection: $currentStep) {
                ForEach(items.smallImagesPortfolio.indices, id: \.self) { index in
                    AsyncImage(url: stringToURL(imageString: items.smallImagesPortfolio[index])){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 450)
                            .clipped()
                            .ignoresSafeArea(.all)
                        
                    } placeholder: {
                        ZStack{
                            ProgressView()
                            Color.gray.opacity(0.2)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    Text("\(currentStep + 1) / \(items.smallImagesPortfolio.count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.bottom, 100)
                        .padding(.trailing, 36)
                }
            }
            .frame(height: 350)
            
    }
    private func sheet() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                AsyncImage(url: stringToURL(imageString: items.avatarAuthor)){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                } placeholder: {
                    ZStack{
                        ProgressView()
                        Color.gray.opacity(0.2)
                            .frame(width: 48, height: 48)
                    }
                }.mask {
                    Circle()
                        .frame(width: 48, height: 48)
                }
                VStack(alignment: .leading){
                    Text(items.author.nameAuthor)
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                    Text("\(items.author.city) \(Locale.current.localizedString(forRegionCode: items.author.countryCode) ?? "")")
                        .font(.callout)
                        .foregroundColor(Color(R.color.gray4.name))
                }
                .padding(12)
                Spacer()
                VStack(alignment: .trailing){
                    Text(R.string.localizable.price_start())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray4.name))
                    Text("\(items.author.priceAuthor)\(currencySymbol(for: items.author.countryCode))")
                        .font(.headline.bold())
                        .foregroundColor(Color(R.color.gray2.name))
                }
            }
            HStack(spacing: 16){
                ForEach(items.author.genreAuthor, id: \.self) { genre in
                    HStack{
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Color(R.color.gray4.name))
                            .frame(width: 20, height: 20)
                        Text(genre)
                            .font(.caption2)
                            .foregroundColor(Color(R.color.gray4.name))
                    }
                }
            }
            Divider()
            Text(items.descriptionAuthor)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
            Divider()
        }.padding(.horizontal, 24)
            .padding(.top, 24)
        .frame(maxWidth: .infinity)
        .background (
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                        .edgesIgnoringSafeArea(.all)
                )
            
    }
    private func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CustomerDetailScreenView_Previews: PreviewProvider {
    private static let mocItems = MockViewModel()
    static var previews: some View {
        CustomerDetailScreenView(items: mocItems.mocData)
    }
}
private class MockViewModel: ObservableObject {
    
    let mocData = AuthorPortfolioModel(id: UUID().uuidString,
                                       author: Author(author: AuthorModel(id: UUID().uuidString,
                                                                          rateAuthor: 4.32,
                                                                          likedAuthor: true,
                                                                          nameAuthor: "Iryna Tandanaeva",
                                                                          countryCode: "th",
                                                                          city: "Phuket",
                                                                          genreAuthor: ["Love Story", "Wedding", "Portrait", "Fashion"],
                                                                          imagesCover: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                                                          priceAuthor: "250")),
                                       avatarAuthor: "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
                                       smallImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1544717304-14d94551b7dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjF8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1608048944439-505d956e1429?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                       largeImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                       descriptionAuthor: "As one of the most important parts of your portfolio, it is imperative that your photographer 'About Me' page appears on your website menu. This practice is a must regardless of whether your bio has a dedicated page or appears as a strip on your one-page website. In any case, your visitors shouldn’t have to click more than once before finding it.",
                                       reviews: [Reviews(review: ReviewsModel(reviewerAuthor: "Safron Sandeev",
                                                                              reviewDescription: "Best photographer on the world",
                                                                              reviewRate: 5.0))],
                                       appointmen: [Appointmen(appointmen: AppointmenModel(data: Date(), timeSlot: [TimeSlot(timeSlot: TimeSlotModel(time: "10:00", available: false)), TimeSlot(timeSlot: TimeSlotModel(time: "11:00", available: true)), TimeSlot(timeSlot: TimeSlotModel(time: "12:00", available: true)), TimeSlot(timeSlot: TimeSlotModel(time: "13:00", available: true)), TimeSlot(timeSlot: TimeSlotModel(time: "14:00", available: false))]))])

}
