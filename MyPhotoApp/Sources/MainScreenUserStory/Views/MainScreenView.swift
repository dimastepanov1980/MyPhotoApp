//
//  MainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/21/23.
//

import SwiftUI

struct MainScreenView<ViewModel: MainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    @Namespace var animation
    @Binding var showSignInView: Bool
    @Binding var showEditOrderView: Bool
    @Binding var showAddOrderView: Bool
    @State var showActionSheet: Bool = false
    @State private var shouldScroll = false
    var statusOrder: StatusOrder

    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>,
         showEditOrderView: Binding<Bool>,
         showAddOrderView: Binding<Bool>,
         statusOrder: StatusOrder) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
        self._showEditOrderView = showEditOrderView
        self._showAddOrderView = showAddOrderView
        self.statusOrder = statusOrder
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { data in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(pinnedViews: [.sectionHeaders, .sectionFooters]) {
                        Section {
                            ScrollView(.vertical) {
                                verticalCards()
                                    .padding(.bottom)
                                    .padding(.top, statusOrder == .Upcoming ? 0 : 80)
                            }
                        
                        } header: {
                            if statusOrder == .Upcoming {
                                headerSection(scroll: data)
                                    .padding(.top, 64)
                            }
                        } .background()
                        
                    }
                }
            }
    
        }
        .background()
        .ignoresSafeArea()
        .onChange(of: showAddOrderView, perform: { _ in
            Task{
                try? await viewModel.loadOrders()
            }
        })
        .task {
            do{
                try? await viewModel.loadOrders()
                try? await viewModel.fetchWeather(lat: "7.837090", lon: "98.294619", exclude: "minutely,hourly,alerts")
            }
        }
            }
    func headerSection(scroll: ScrollViewProxy) -> some View {
        VStack() {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(R.string.localizable.today())
                        .font(.subheadline.bold())
                        .foregroundColor(Color(R.color.gray3.name))
                    
                    HStack {
                        Text(viewModel.formattedDate(date: viewModel.today, format: "dd MMMM"))
                            .font(.title.bold())
                            .foregroundColor(Color(R.color.gray1.name))
                        //    ToDo: need to updete date avery time then we lunch app - this method do it not coorect -
                        //                            .onAppear {
                        //                                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        //                                    viewModel.today = Date()
                        //                                }
                        //                            }
                        
                        // TODO: Обработка погоды на сегодня
                        
                        if let weather = viewModel.weatherForCurrentDay {
                            let url = URL(string: "https://openweathermap.org/img/wn/\(weather)@2x.png")
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "cloud.snow")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                    }
                }
//                Spacer()
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
            ForEach(viewModel.filteredOrdersForToday, id: \.id) { order in
                NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: $showEditOrderView)
                    .navigationBarBackButtonHidden(true)) {
                        HCellMainScreenView(items: order)
                            .contextMenu {
                                Button("Remove Order") {
                                    Task {
                                        try? await viewModel.deleteOrder(order: order)
                                        try? await viewModel.loadOrders()
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
                        if let icon = icon {
                            if let url = URL(string: "https://openweathermap.org/img/wn/\(icon.icon)@2x.png") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        } else {
                            Image(systemName: "cloud.snow")
                                .resizable()
                                .frame(width: 16, height: 16)
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
                        ForEach(statusOrder == .Upcoming ? viewModel.filteredUpcomingOrders[date]! : viewModel.filteredOtherOrders[date]! , id: \.date) { order in
                            NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: $showEditOrderView)
                                .navigationBarBackButtonHidden(true)) {
                                    VCellMainScreenView(items: order)
                                        .contextMenu {
                                            Button("Remove Order") {
                                                Task{
                                                    try? await viewModel.deleteOrder(order: order)
                                                    try? await viewModel.loadOrders()
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
struct MainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    static var previews: some View {
        MainScreenView(with: mockModel, showSignInView: .constant(true), showEditOrderView: .constant(true), showAddOrderView: .constant(false), statusOrder: .Upcoming)
    }
}
private class MockViewModel: MainScreenViewModelType, ObservableObject {
    var filteredOtherOrders: [Date : [UserOrdersModel]] = [:]
    
    
    var filteredOrdersForToday: [UserOrdersModel] = []
    var filteredUpcomingOrders: [Date : [UserOrdersModel]] = [:]
    var vm = MainScreenViewModel()
    
    @Published var weatherByDate = [Date : [Weather?]]()
    @Published var weatherForCurrentDay: String? = nil
    @Published var weaterId: String = ""
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    @Published var orders: [UserOrdersModel] = [UserOrdersModel(order: OrderModel(orderId: UUID().uuidString,
                                                                                  name: "Katy Igor",
                                                                                  instagramLink: nil,
                                                                                  price: "5500",
                                                                                  location: "Kata",
                                                                                  description: "Some Text",
                                                                                  date: Date(),
                                                                                  duration: "2",
                                                                                  imageUrl: [],
                                                                                  status: "Upcoming"))]
    
    init() {}
    
    func fetchWeather(lat: String, lon: String, exclude: String) async throws {
        //
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
    func deleteOrder(order: UserOrdersModel) async throws {
        //
    }
    func loadOrders() async throws {
        //
    }
}
