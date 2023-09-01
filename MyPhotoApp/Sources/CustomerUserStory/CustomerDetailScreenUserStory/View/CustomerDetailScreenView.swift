//
//  CustomerDetailScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/21/23.
//

import SwiftUI

struct CustomerDetailScreenView<ViewModel: CustomerDetailScreenViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var currentStep = 0
    @Binding var showDetailView: Bool
    @State var showOrderConfirm: Bool = false

    @State var orderDescription: String = R.string.localizable.default_message()


    init(with viewModel: ViewModel,
         showDetailView: Binding<Bool>){
        self.viewModel = viewModel
        self._showDetailView = showDetailView
    }

   var body: some View {
            ScrollView(showsIndicators: false){
                VStack{
                    slider
                    Spacer()
                    bottomSheet
                        .offset(y: -110)
                }
            }
           .safeAreaInset(edge: .bottom) {
               VStack{
                   HStack(spacing: 16){
                       if let selectedDay = viewModel.selectedDay {
                           HStack(spacing: 2) {
                               Image(systemName: "calendar")
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray1.name))
                               
                               Text(viewModel.formattedDate(date: selectedDay, format: "dd MMMM"))
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray3.name))
                           }
                       }
                       if let time = viewModel.sortedDate(array: viewModel.selectedTime).first {
                           
                           HStack(spacing: 2) {
                               Image(systemName: "clock")
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray1.name))
                               Text(time)
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray3.name))
                           }
                           
                           
                           HStack(spacing: 2){
                               Image(systemName: "timer")
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray1.name))
                               Text("\(viewModel.selectedTime.count)")
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray3.name))
                           }
                       }
                   }
                   if let author = viewModel.items.author {
                       if viewModel.selectedDay != nil {
                           if viewModel.selectedTime.isEmpty {
                               CustomButtonXl(titleText: "\(R.string.localizable.select_time()) ", iconName: "") {
                                   // Action
                               }
                           } else {
                               CustomButtonXl(titleText: "\(R.string.localizable.reservation_button()) \(totalCost(price: viewModel.items.author?.priceAuthor, timeSlot: viewModel.selectedTime))\(viewModel.currencySymbol(for: author.countryCode))", iconName: "") {
                                   showOrderConfirm.toggle()
                               }.fullScreenCover(isPresented: $showOrderConfirm) {
                                   CustomerConfirmOrderView(with: CustomerConfirmOrderViewModel(author: viewModel.items, orderDate: viewModel.selectedDay ?? Date(), orderTime: viewModel.selectedTime, orderDuration: String(viewModel.selectedTime.count), orderPrice: totalCost(price: viewModel.items.author?.priceAuthor, timeSlot: viewModel.selectedTime), orderDescription: $orderDescription), showOrderConfirm: $showOrderConfirm)
                                   
                               }
                           }
                       } else {
                           CustomButtonXl(titleText: "\(R.string.localizable.select_date()) ", iconName: "") {
                               // Action
                           }
                       }
                   }
               }.padding(.top, 4)
                   .background(Color(R.color.gray7.name))
                    }
           .background(Color(R.color.gray7.name))
    }
    
    private struct ParallaxHeader<Content: View>: View {
        @ViewBuilder var content: () -> Content
        var body: some View {
            GeometryReader { gr in
                let minY = gr.frame(in: .global).minY
                content()
                    .frame(
                        width: gr.size.width,
                        height: gr.size.height + max(minY * 0.3, 0)
                    )
                    .offset(y: -minY)
            }
        }
    }
    private var authorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                AsyncImage(url: viewModel.stringToURL(imageString: viewModel.items.avatarAuthor)){ image in
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
                if let author = viewModel.items.author {
                    VStack(alignment: .leading){
                        Text("\(author.nameAuthor) \(author.familynameAuthor)")
                            .font(.title2.bold())
                            .foregroundColor(Color(R.color.gray1.name))
                        Text("\(author.city), \(Locale.current.localizedString(forRegionCode: author.countryCode) ?? "")")
                            .font(.callout)
                            .foregroundColor(Color(R.color.gray4.name))
                    }
                    .padding(12)
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(R.string.localizable.price_start())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray4.name))
                        Text("\(author.priceAuthor)\(viewModel.currencySymbol(for: author.countryCode))")
                            .font(.headline.bold())
                            .foregroundColor(Color(R.color.gray2.name))
                    }
                }
            }
            
            if let author = viewModel.items.author {
                HStack(spacing: 16){
                    ForEach(author.genreAuthor, id: \.self) { genre in
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
            }
                Text(viewModel.items.descriptionAuthor)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
                
        }
        .padding(.top, 24)

    }
    private var timeSlotSection: some View {
        VStack(alignment: .leading, spacing: 6){
            Group {
                Divider()
                Text(R.string.localizable.select_date())
                    .font(.caption2)
                    .foregroundColor(Color(R.color.gray3.name))
            }
            .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 8 ) {
                    ForEach(viewModel.items.appointmen, id: \.id) { date in
                        VStack{
                            VStack(alignment: .center, spacing: 2) {
                                Text("\(viewModel.formattedDate(date: date.data, format: "dd"))")
                                    .font(.body.bold())
                                    .foregroundColor(viewModel.isToday(date: date.data) ? Color(R.color.gray7.name) : Color(R.color.gray2.name))
                                Text("\(viewModel.formattedDate(date: date.data, format: "MMM"))")
                                    .font(.footnote)
                                    .foregroundColor(viewModel.isToday(date: date.data) ? Color(R.color.gray5.name) : Color(R.color.gray3.name))
                            }
                            .padding(.vertical, 20)
                            .frame(width: 45)
                            .background(
                                ZStack {
                                    Capsule()
                                        .strokeBorder(Color(R.color.gray4.name), lineWidth: 0.5)
                                        .opacity(viewModel.isTodayDay(date: Date()) ? 1 : 0)
                                }
                            )
                            .background(
                                ZStack {
                                    if viewModel.isToday(date: date.data) {
                                        Capsule()
                                            .fill(Color(R.color.gray2.name))
                                    }
                                }
                            )
                            .containerShape(Capsule())
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedDay = date.data
                                    viewModel.selectedTime = []
                                    viewModel.timeslotSelectedDay = date.timeSlot
                                }
                            }
                        
                        }
                    }
                }
                .padding(.leading, 24)
            }
            .padding(.bottom, 12)
            
            Group {
            Divider()
            if viewModel.selectedDay != nil {
            Text(R.string.localizable.select_time())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray3.name))
            
            FlexibleView(
                data: viewModel.timeslotSelectedDay,
                spacing: 6,
                alignment: .leading) { time in
                    tagTime(time: time.time, available: time.available)
                }
              }
            }
            .padding(.horizontal, 24)
        }
    }
    private func tagTime(time: String, available: Bool) -> some View{
        Group{
            if viewModel.selectedTime.contains(time) {
                Text(time)
                    .font(.footnote)
                    .foregroundColor(available ? Color(R.color.gray7.name) : Color(R.color.gray7.name))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            Capsule()
                                .strokeBorder(!available ? Color(R.color.gray5.name) : .clear, lineWidth: 1)
                                .frame(width: 50, height: 27)
                        }
                    )
                    .background(
                        ZStack {
                            Capsule()
                                .fill(available ? Color(R.color.gray2.name) : Color(R.color.gray7.name))
                                .frame(width: 50, height: 27)
                        }
                    )
            } else {
                Text(time)
                    .font(.footnote)
                    .foregroundColor(available ? Color(R.color.gray2.name) : Color(R.color.gray5.name))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            Capsule()
                                .strokeBorder(available ? Color(R.color.gray4.name) : Color(R.color.gray5.name), lineWidth: 0.5)
                                .frame(width: 50, height: 27)
                        }
                    )
                    .background(
                        ZStack {
                            Capsule()
                                .fill(Color(R.color.gray7.name))
                                .frame(width: 50, height: 27)
                        }
                    )
            }
        }
        .onTapGesture {
            if available {
                if viewModel.selectedTime.contains(time) {
                    viewModel.selectedTime.removeAll { $0 == time }
                } else {
                    viewModel.selectedTime.append(time)
                }
            }
        }
    }
    private var slider: some View {
        ParallaxHeader{
            TabView(selection: $currentStep) {
                ForEach(viewModel.items.smallImagesPortfolio.indices, id: \.self) { index in
                    AsyncImage(url: viewModel.stringToURL(imageString: viewModel.items.smallImagesPortfolio[index])){ image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 450)
                            .clipped()
                        
                    } placeholder: {
                        ZStack{
                            ProgressView()
                            Color.gray.opacity(0.2)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                   showDetailView.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color(R.color.gray3.name).opacity(0.5))
                }.padding(.top, 48)
                    .padding(.trailing, 36)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 350)
    }
    private var bottomSheet: some View {
        VStack(spacing: 20){
            authorSection
                .padding(.horizontal, 24)
            timeSlotSection
        }
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(Color(R.color.gray7.name))
                .cornerRadius(25, corners: [.topLeft, .topRight])
            )
        .overlay(alignment: .topTrailing) {
            Group {
                Text("\(currentStep + 1) / \(viewModel.items.smallImagesPortfolio.count)")
                    .font(.caption2)
                    .foregroundColor(Color(R.color.gray7.name))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    .padding(.trailing, 36)
            }
            .offset(y: -50)
        }
    }
    private func totalCost(price: String?, timeSlot: [String]) -> String {
        String(describing: (Int(price ?? "0") ?? 0) * timeSlot.count)
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
private struct RoundedCorner: Shape {
    
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
        CustomerDetailScreenView(with: mocItems, showDetailView: .constant(true))
    }
}
private class MockViewModel: CustomerDetailScreenViewModelType, ObservableObject {
    @Published var items: AuthorPortfolioModel =
    AuthorPortfolioModel(portfolio:
                            DBPortfolioModel(id: UUID().uuidString,
                                             author:  DBAuthor(id: UUID().uuidString,
                                                               rateAuthor: 4.32,
                                                               likedAuthor: true,
                                                               nameAuthor: "Iryna",
                                                               familynameAuthor: "Test",
                                                               sexAuthor: "Female",
                                                               countryCode: "th",
                                                               city: "Phuket",
                                                               genreAuthor: ["Test", "Test", "Test", "Test"],
                                                               imagesCover: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                                               priceAuthor: "1234"),
                                             
                                             avatarAuthor: "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
                                             
                                             smallImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1544717304-14d94551b7dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjF8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1608048944439-505d956e1429?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                             
                                             largeImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1544717304-14d94551b7dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjF8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1608048944439-505d956e1429?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                             
                                             descriptionAuthor: "As one of the most important parts of your portfolio, it is imperative that your photographer 'About Me' page appears on your website menu. This practice is a must regardless of whether your bio has a dedicated page or appears as a strip on your one-page website. In any case, your visitors shouldn’t have to click more than once before finding it.",

                                             reviews: [DBReviews(reviewerAuthor: "Safron Sandeev",
                                                                                      reviewDescription: "Best photographer on the world",
                                                                                      reviewRate: 5.0)],

                                             appointmen: [
                                                DBAppointmen(data: Date(), timeSlot: [
                                                    DBTimeSlot(time: "09:00", available: true),
                                                    DBTimeSlot(time: "10:00", available: false),
                                                    DBTimeSlot(time: "11:00", available: true),
                                                    DBTimeSlot(time: "12:00", available: true),
                                                    DBTimeSlot(time: "13:00", available: true),
                                                    DBTimeSlot(time: "14:00", available: false),
                                                    DBTimeSlot(time: "15:00", available: false),
                                                    DBTimeSlot(time: "16:00", available: true),
                                                    DBTimeSlot(time: "17:00", available: false),
                                                    DBTimeSlot(time: "18:00", available: true),
                                                    DBTimeSlot(time: "19:00", available: false),
                                                    DBTimeSlot(time: "20:00", available: true) ]),
                                                
                                                DBAppointmen(data: Date(), timeSlot: [
                                                    DBTimeSlot(time: "09:30", available: true),
                                                    DBTimeSlot(time: "10:30", available: false),
                                                    DBTimeSlot(time: "11:30", available: true),
                                                    DBTimeSlot(time: "12:30", available: true),
                                                    DBTimeSlot(time: "13:30", available: true),
                                                    DBTimeSlot(time: "14:30", available: false),
                                                    DBTimeSlot(time: "15:30", available: false),
                                                    DBTimeSlot(time: "16:30", available: true),
                                                    DBTimeSlot(time: "17:30", available: false),
                                                    DBTimeSlot(time: "18:30", available: true),
                                                    DBTimeSlot(time: "19:30", available: false),
                                                    DBTimeSlot(time: "20:30", available: true) ])
                                                                                        ]))
    
    @Published var selectedTime: [String] = []
    @Published var selectedDay: Date? = Date()
    @Published var today: Date = Date()
    @Published var timeslotSelectedDay: [DBTimeSlot] = []
    
    func sortedDate(array: [String]) -> [String] {
        []
    }
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func stringToURL(imageString: String) -> URL? {
        guard let imageURL = URL(string: imageString) else { return nil }
        return imageURL
    }
    func currencySymbol(for regionCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: regionCode]))
        guard let currency = locale.currencySymbol else { return "$" }
        return currency
    }
    func isTodayDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(today, inSameDayAs: date)
    }
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDay ?? Date(), inSameDayAs: date)
    }


}
