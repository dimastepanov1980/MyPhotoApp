//
//  CustomerDetailScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/21/23.
//

import SwiftUI

struct CustomerDetailScreenView<ViewModel: CustomerDetailScreenViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var router: Router<Views>

    @State private var currentStep = 0
    @State var showOrderConfirm: Bool = false
    @State var showPortfolioDetailScreenView: Bool = false
    @Namespace var timeID
    @State var orderDescription: String = R.string.localizable.default_message()
    
    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }


   var body: some View {
           ScrollViewReader { proxy in
               ScrollView(showsIndicators: false){
                   VStack{
                       ParallaxHeader{
                           TabView(selection: $currentStep) {
                               ForEach(viewModel.portfolio.smallImagesPortfolio.indices, id: \.self) { index in
                                       AsyncImageView(imagePath: viewModel.portfolio.smallImagesPortfolio[index])
                                       .navigationDestination(isPresented: $showPortfolioDetailScreenView) {
                                           PortfolioDetailScreenView(images: viewModel.portfolio.smallImagesPortfolio)
                                       }
                                       .onTapGesture {
                                           showPortfolioDetailScreenView.toggle()
                                       }
                               }
                           }
                       }
                       .tabViewStyle(.page(indexDisplayMode: .never))
                       .frame(height: 350)
                       Spacer()
                       bottomSheet
                           .offset(y: -110)
                   }
                   .navigationBarBackButtonHidden(true)
                   .navigationBarItems(leading: customBackButton)
                   .toolbarBackground(.hidden, for: .navigationBar)
                   .onChange(of: viewModel.startScheduleDay) { _ in
                           withAnimation {
                               proxy.scrollTo(timeID)
                           }

                   }
           }
           
           }
           .safeAreaInset(edge: .bottom) {
               VStack{
                   HStack(spacing: 16){
                           HStack(spacing: 2) {
                               Image(systemName: "calendar")
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray1.name))
                               
                               Text(viewModel.formattedDate(date: viewModel.startScheduleDay, format: "dd MMMM"))
                                   .font(.subheadline)
                                   .foregroundColor(Color(R.color.gray3.name))
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
                   if let author = viewModel.portfolio.author {
                           if viewModel.selectedTime.isEmpty {
                               CustomButtonXl(titleText: "\(R.string.localizable.select_time()) ", iconName: "") {
                                   // Action
                               }
                               .padding(.horizontal)
                           } else {
                               
                               CustomButtonXl(titleText: "\(R.string.localizable.reservation_button()) \(totalCost(price: viewModel.priceForDay, timeSlot: viewModel.selectedTime))\(viewModel.currencySymbol(for: author.regionAuthor))", iconName: "") {
                                   showOrderConfirm = true
                                   
                               }
                               .padding(.horizontal)
                           }
                     
                   }
               }
               .padding(.top, 4)
               .background(Color(R.color.gray7.name))
           }
           .background(Color(R.color.gray7.name))
           .fullScreenCover(isPresented: $showOrderConfirm) {
                   CustomerConfirmOrderView(with: CustomerConfirmOrderViewModel(
                    author: viewModel.portfolio,
                    orderDate: viewModel.startScheduleDay,
                    orderTime: viewModel.selectedTime,
                    orderDuration: String(viewModel.selectedTime.count),
                    orderPrice: totalCost(price: viewModel.priceForDay, timeSlot: viewModel.selectedTime)),
                                            showOrderConfirm: $showOrderConfirm)
           }
    }
    private var customBackButton : some View {
        Button {
            router.pop()
        } label: {
            HStack{
                Image(systemName: "chevron.left.circle.fill")// set image here
                    .font(.title)
                    .foregroundStyle(Color(.systemBackground), Color(R.color.gray1.name).opacity(0.7))
           
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
                        height: gr.size.height + max(minY * 0.3, 0)
                    )
                    .offset(y: -minY)
            }
        }
    }
    private var authorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                AsyncImageView(imagePath: viewModel.portfolio.avatarAuthor)
                     .frame(width: 68, height: 68)
                     .mask {
                          Circle()
                      }

                if let author = viewModel.portfolio.author {
                    VStack(alignment: .leading){
                        Text("\(author.nameAuthor) \(author.familynameAuthor)")
                            .font(.title2.bold())
                            .foregroundColor(Color(R.color.gray1.name))
                        Text("\(author.location)")
                            .font(.callout)
                            .foregroundColor(Color(R.color.gray4.name))
                    }
                    .padding(12)
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(R.string.localizable.price_start())
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray4.name))
                        
                        Text("\(viewModel.minPrice) \(viewModel.currencySymbol(for: viewModel.portfolio.author?.regionAuthor ?? "$"))")
                            .font(.headline)
                            .foregroundColor(Color(R.color.gray2.name))
                        
                    }
                }
            }
            
            if let author = viewModel.portfolio.author {
                HStack(spacing: 16){
                    ForEach(author.styleAuthor, id: \.self) { genre in
                        HStack{
                            Image(systemName: imageStyleAuthor(genre: genre))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(R.color.gray2.name))
                                .frame(width: 15, height: 13)
                            Text(genre)
                                .font(.caption2)
                                .foregroundColor(Color(R.color.gray4.name))
                        }
                    }
                }
                Divider()
            }
            if !viewModel.portfolio.descriptionAuthor.isEmpty {
                
                Text(viewModel.portfolio.descriptionAuthor)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
            Divider()
            }
               
        }
        .padding(.top, 24)

    }
    private var timeSlotSection: some View {
        VStack(alignment: .leading, spacing: 6){
            
            Group {
                
                Text(R.string.localizable.select_date())
                    .font(.caption2)
                    .foregroundColor(Color(R.color.gray3.name))
            }
            .padding(.horizontal, 24)
            if !viewModel.appointments.isEmpty{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 8 ) {
                    
                    ForEach(viewModel.appointments, id: \.date) { appointment in
                            VStack{
                                VStack(alignment: .center, spacing: 2) {
                                    Text("\(viewModel.formattedDate(date: appointment.date, format: "dd"))")
                                        .font(.body.bold())
                                        .foregroundColor(viewModel.selectedDate(date: appointment.date) ? Color(R.color.gray7.name) : Color(R.color.gray2.name))
                                    Text("\(viewModel.formattedDate(date: appointment.date, format: "MMM"))")
                                        .font(.footnote)
                                        .foregroundColor(viewModel.selectedDate(date: appointment.date) ? Color(R.color.gray5.name) : Color(R.color.gray3.name))
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
                                        if viewModel.selectedDate(date: appointment.date) {
                                            Capsule()
                                                .fill(Color(R.color.gray2.name))
                                        }
                                    }
                                )
                                .containerShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        self.viewModel.startScheduleDay = appointment.date
                                        self.viewModel.selectedTime = []
                                        self.viewModel.timeslotSelectedDay = appointment.timeSlot
                                        self.viewModel.priceForDay = appointment.price
                                        
                                        print("selected Day Time and Price: \(viewModel.startScheduleDay):\(viewModel.selectedTime):\(viewModel.priceForDay)")
                                    }
                                }
                                
                            }
                        }
                    
                }
                .padding(.leading, 24)
            }
            .padding(.bottom, 12)
            } else {
                VStack {
                    Spacer()
                    
                    Text(R.string.localizable.select_date_no_dates())
                        .font(.title3)
                        .foregroundColor(Color(R.color.gray2.name))
                        .multilineTextAlignment(.center)
                   
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Group {
                Divider()
            Text(R.string.localizable.select_time())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray3.name))
            
            FlexibleView(
                data: viewModel.timeslotSelectedDay,
                spacing: 6,
                alignment: .leading) { time in
                    tagTime(time: time)
                       
                }
                .id(timeID)
                
            }
            .padding(.horizontal, 24)
        }
    }
    private func tagTime(time: String) -> some View{
        Group{
            if viewModel.selectedTime.contains(time) {
                Text(time)
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray7.name))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                   
                    .background(
                        ZStack {
                            Capsule()
                                .fill(Color(R.color.gray2.name))
                                .frame(width: 50, height: 27)
                        }
                    )
            } else {
                Text(time)
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            Capsule()
                                .strokeBorder(Color(R.color.gray4.name), lineWidth: 0.5)
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
            if viewModel.selectedTime.contains(time) {
                self.viewModel.selectedTime.removeAll { $0 == time }
                print("selected Day RemoveTime and Price: \(viewModel.startScheduleDay):\(viewModel.selectedTime):\(viewModel.priceForDay)")

            } else {
                self.viewModel.selectedTime.append(time)
                print("selected Day AppendTime and Price: \(viewModel.startScheduleDay):\(viewModel.selectedTime):\(viewModel.priceForDay)")

            }
        }
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
                Text("\(currentStep + 1) / \(viewModel.portfolio.smallImagesPortfolio.count)")
                    .font(.caption2)
                    .foregroundColor(Color.white)
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
    private func imageStyleAuthor(genre: String) -> String {
        switch genre {
        case "Aerial":
            return "paperplane.fill";
        case "Architecture":
            return "building.2.fill";
        case "Documentary":
            return "film";
        case "Event":
            return "balloon.2.fill";
        case "Fashion":
            return "mouth";
        case "Food":
            return "cup.and.saucer.fill";
        case "Love Story":
            return "heart.fill";
        case "Macro":
            return "camera.macro";
        case "People":
            return "person.fill";
        case "Pet":
            return "pawprint.fill";
        case "Portraits":
            return "person.crop.circle.fill";
        case "Product":
            return "car.fill";
        case "Real Estate":
            return "house.fill";
        case "Sports":
            return "figure.run";
        case "Wedding":
            return "heart";
        case "Wildlife":
            return "hare.fill";
        default:
            return "camera"
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
                        Color(R.color.gray5.name)
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
        CustomerDetailScreenView(with: mocItems)
    }
}
private class MockViewModel: CustomerDetailScreenViewModelType, ObservableObject {
    func getMinPrice(appointmen: [DbSchedule]) {}
    var avatarImage: UIImage?
    func getAvatarImage(imagePath: String) async throws {}
    var minPrice: String = ""
    var priceForDay: String = ""
    func createAppointments(schedule: [DbSchedule], startMyTripDate: Date, bookingDays: [String : [String]]) {}

    @Published var appointments: [AppointmentModel] = []
    @Published var portfolio: AuthorPortfolioModel = AuthorPortfolioModel(portfolio:
                                                DBPortfolioModel(id: UUID().uuidString,
                                                                 author:   DBAuthor(rateAuthor: 0.0,
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
                                                                 smallImagesPortfolio: [],
                                                                 largeImagesPortfolio: [],
                                                                 descriptionAuthor: "",
                                                                 schedule: [DbSchedule(id: UUID(), holidays: true, startDate: Date(), endDate: Date(), timeIntervalSelected: "1", price: "4400", timeZone: "")],
                                                                 bookingDays: [:]))
    @Published var selectedTime: [String] = []
    @Published var startScheduleDay: Date = Date()
    @Published var today: Date = Date()
    @Published var timeslotSelectedDay: [String] = []
    
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
    func selectedDate(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(startScheduleDay, inSameDayAs: date)
    }


}

