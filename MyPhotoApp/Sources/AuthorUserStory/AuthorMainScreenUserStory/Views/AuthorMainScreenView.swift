//
//  AuthorMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/21/23.
//

import SwiftUI
import Combine
import MapKit

struct AuthorMainScreenView<ViewModel: AuthorMainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    @Namespace var animation
    @Binding var showSignInView: Bool
    @Binding var showEditOrderView: Bool
    @State var showActionSheet: Bool = false
    @State private var shouldScroll = false
    var statusOrder: StatusOrder
    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>,
         showEditOrderView: Binding<Bool>,
         statusOrder: StatusOrder) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
        self._showEditOrderView = showEditOrderView
        self.statusOrder = statusOrder
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { data in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            ScrollView(.vertical) {
                                verticalCards()
                                    .padding(.bottom)
                                    .padding(.top, statusOrder == .Upcoming ? 0 : 32)
                            }
                        } header: {
                            if statusOrder == .Upcoming {
                                headerSection(scroll: data)
                                    .padding(.top, 64)
                            }
                        }
                        .background(Color(R.color.gray7.name))
                    }
                }.padding(.vertical, 32)
            }
            
        }
        .background(Color(R.color.gray7.name))
        .ignoresSafeArea()
    }
    func headerSection(scroll: ScrollViewProxy) -> some View {
        VStack() {
            HStack {
                VStack(alignment: .center, spacing: 0) {
                    Text(R.string.localizable.today())
                        .font(.subheadline.bold())
                        .foregroundColor(Color(R.color.gray3.name))
                    
                    HStack {
                        Text(viewModel.formattedDate(date: viewModel.today, format: "dd MMMM"))
                            .font(.title.bold())
                            .foregroundColor(Color(R.color.gray1.name))
                        if let returnedIcon = viewModel.weatherForCurrentDay {
                            Image(systemName: viewModel.getIconForWeatherCode(weatherCode: returnedIcon))
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 24))
                                .foregroundStyle(Color(R.color.gray4.name), Color(R.color.upcoming.name))
                        } else {
                            Image(systemName: "icloud.slash")
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 24))
                                .foregroundStyle(Color(R.color.upcoming.name), Color(R.color.gray4.name))
                        }
                        
                    }
                }
            }.padding(.horizontal, 32)
            ScrollView(.horizontal, showsIndicators: false) {
                horizontalCards
            }
            ScrollView(.horizontal, showsIndicators: false) {
                calendarSection(value: scroll)
            }
        }
    }
    var horizontalCards: some View {
        LazyHStack {
            ForEach(viewModel.filteredOrdersForToday, id: \.orderId) { order in
                NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: $showEditOrderView)
                    .navigationBarBackButtonHidden(true)) {
                        AuthorHCellMainScreenView(items: order)
                            .contextMenu {
                                Button(R.string.localizable.order_Delete()) {
                                    Task {
                                        try? await viewModel.deleteOrder(order: order)
                                    }
                                }
                            }
                    }
            }
        }.padding(.horizontal)
    }
    func calendarSection(value: ScrollViewProxy) -> some View {
        HStack(alignment: .bottom, spacing: 8 ) {
            ForEach(viewModel.weatherByDate.keys.sorted(), id: \.self) { day in
                ForEach(viewModel.weatherByDate[day]!, id: \.self) { icon in
                    VStack(spacing: 4) {
                        Spacer()
                        if let returnedItem = icon {
                            Image(systemName: viewModel.getIconForWeatherCode(weatherCode: returnedItem.icon))
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 16))
                                .foregroundStyle(Color(R.color.gray4.name), Color(R.color.upcoming.name))
                        } else {
                            Image(systemName: "icloud.slash")
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 14))
                                .foregroundStyle(Color(R.color.upcoming.name), Color(R.color.gray4.name))
                        }
                        Text(viewModel.formattedDate(date: day, format: "dd"))
                            .font(.body.bold())
                            .foregroundColor(Color(R.color.gray2.name))
                        Text(viewModel.formattedDate(date: day, format: "EEE"))
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray3.name))
                        
                        HStack(spacing: 2) {
                            ForEach(viewModel.filteredUpcomingOrders.keys.sorted(), id: \.self) { date in
                                ForEach(viewModel.filteredUpcomingOrders[date]!, id: \.date) { index in
                                    if viewModel.formattedDate(date: day, format: "dd, MM, YYYY") == viewModel.formattedDate(date: index.date, format: "dd, MM, YYYY") {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(height: 6)
                                    }
                                }
                            }
                            
                            ForEach(viewModel.filteredOrdersForToday, id: \.date) { item in
                                if viewModel.formattedDate(date: day, format: "dd, MM, YYYY") == viewModel.formattedDate(date: item.date, format: "dd, MM, YYYY") {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(height: 6)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
                .frame(width: 50, height: 100)
                .background(
                    ZStack {
                        if viewModel.isTodayDay(date: day) {
                            Capsule()
                                .strokeBorder(Color(R.color.gray4.name), lineWidth: 1)
                                .opacity(viewModel.isTodayDay(date: Date()) ? 1 : 0)
                        }
                    }
                )
                .background(
                    ZStack {
                        if viewModel.isToday(date: day) {
                            Capsule()
                                .fill(Color(R.color.gray5.name))
                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                        }
                    }
                )
                .containerShape(Capsule())
                .onTapGesture {
                    withAnimation {
                        viewModel.selectedDay = day
                        shouldScroll.toggle()
                    }
                    // MARK: - make animation scroll
                    value.scrollTo(viewModel.formattedDate(date: viewModel.selectedDay, format: "dd MMMM YYYY" ), anchor: .top)
                }
            }
        }
        .padding()
    }
    func verticalCards() -> some View {
        VStack(alignment: .center) {
                ForEach(statusOrder == .Upcoming ? viewModel.filteredUpcomingOrders.keys.sorted() : viewModel.filteredOtherOrders.keys.sorted(), id: \.self) { date in
                    Section(header: Text(date, style: .date)
                        .id(viewModel.formattedDate(date: date, format: "dd MMMM YYYY" ))
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray3.name))) {
                            ForEach(statusOrder == .Upcoming ? viewModel.filteredUpcomingOrders[date]! : viewModel.filteredOtherOrders[date]! , id: \.orderId) { order in
                                NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: $showEditOrderView)
                                    .navigationBarBackButtonHidden(true)) {
                                        AuthorVCellMainScreenView(items: order, statusColor: viewModel.orderStausColor(order: order.status), status: viewModel.orderStausName (status: order.status))
                                            .contextMenu {
                                                Button(R.string.localizable.order_Delete()) {
                                                    Task{
                                                        try? await viewModel.deleteOrder(order: order)
                                                    }
                                                }
                                            }
                                    }
                            }
                        }
                }
        }  .padding(.horizontal)
    }
}
// MARK: Формтируем дату в День месяц
extension Date {
    var displayDayToday: String {
        self.formatted(
            .dateTime
                .day()
                .month(.abbreviated)
        )
    }
}

struct AuthorMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    static var previews: some View {
        AuthorMainScreenView(with: mockModel, showSignInView: .constant(true), showEditOrderView: .constant(true), statusOrder: .Upcoming)
    }
}
private class MockViewModel: AuthorMainScreenViewModelType, ObservableObject {
    func fetchWeather(with location: CLLocation) {
    }
    
    func getIconForWeatherCode(weatherCode: String) -> String {
        return ""
    }
    
    func orderStausName(status: String?) -> String {
        "Upcoming"
    }
    var filteredOtherOrders: [Date : [DbOrderModel]] = [:]
    var filteredOrdersForToday: [DbOrderModel] = []
    var filteredUpcomingOrders: [Date : [DbOrderModel]] = [:]
    var vm = AuthorMainScreenViewModel()
    var location = LocationService()
    
    @Published var weatherByDate = [Date : [Weather?]]()
    @Published var weatherForCurrentDay: String? = nil
    @Published var weaterId: String = ""
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    @Published var orders: [DbOrderModel] = [DbOrderModel(order:
                                        AuthorOrderModel(orderId: UUID().uuidString,
                                                          orderCreateDate: Date(),
                                                         orderPrice: "5500",
                                                         name: "Katy Igor",
                                                         instagramLink: nil,
                                                          location: "Kata",
                                                          description: "Some Text",
                                                          date: Date(),
                                                          duration: "2",
                                                          imageUrl: [],
                                                          status: "Upcoming"))]
    
    init() {}
    
    func fetchWeather() async throws {
        //
    }
    func orderStausColor(order: String?) -> Color {
        return Color.gray
    }
    
    func formattedDate(date: Date, format: String) -> String {
        return ""
    }
    func isToday(date: Date) -> Bool {
        return true
    }
    func isTodayDay(date: Date) -> Bool {
        return true
    }
    func deleteOrder(order: DbOrderModel) async throws {
        //
    }
}

