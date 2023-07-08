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

    var filteredOrdersForToday: [UserOrdersModel] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        return viewModel.orders.filter { order in
            let formattedOrderDate = dateFormatter.string(from: order.date)
            let formattedToday = dateFormatter.string(from: today)
            return formattedOrderDate == formattedToday
        }
    }
    var filteredOrdersByDate: [Date : [UserOrdersModel]] {
        var filteredOrders = [Date : [UserOrdersModel]]()
        
        let currentDate = Calendar.current.startOfDay(for: Date()) // Get the current date without time
        
        for order in viewModel.orders {
            let date = Calendar.current.startOfDay(for: order.date) // Get the order date without time
            
            if date > currentDate {
                let orderDate = Calendar.current.startOfDay(for: date)
                if filteredOrders[orderDate] == nil {
                    filteredOrders[orderDate] = [order]
                } else {
                    filteredOrders[orderDate]?.append(order)
                }
            }
        }
        return filteredOrders
    }
    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>,
         showEditOrderView: Binding<Bool>,
         showAddOrderView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
        self._showEditOrderView = showEditOrderView
        self._showAddOrderView = showAddOrderView
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { date in
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders, .sectionFooters]) {
                        Section {
                            ScrollView(.vertical) {
                                verticalCards
                            }
                        } header: {
                            headerSection
                                .padding(.top, 64)
                        } .background()
                    }
                }.edgesIgnoringSafeArea(.bottom)
                    .ignoresSafeArea()
                    .padding(.bottom)
            }
          
            
            CustomButtonXl(titleText: R.string.localizable.takeAPhoto(), iconName: "camera.aperture") {
                showAddOrderView.toggle()
            }.background()
        } .onChange(of: showAddOrderView, perform: { _ in
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
        .fullScreenCover(isPresented: $showAddOrderView) {
            NavigationStack {
                AddOrderView(with: AddOrderViewModel(order: UserOrdersModel(order: OrderModel(orderId: <#T##String#>, name: <#T##String?#>, instagramLink: <#T##String?#>, price: <#T##String?#>, location: <#T##String?#>, description: <#T##String?#>, date: <#T##Date#>, duration: <#T##String#>, imageUrl: <#T##[String]#>))), showAddOrderView: $showEditOrderView, mode: .new)
            }
        }
        
    }
    private var headerSection: some View {
        VStack(spacing: 16) {
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
                Spacer()
                
                Button {
                } label: {
                    NavigationLink {
                        SettingScreenView(with: SettingScreenViewModel(), showSignInView: $showSignInView)
                        
                    } label: {
                        
                        Image(R.image.image0.name)
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56)
                            .overlay(Circle().stroke(Color.white,lineWidth: 2).shadow(radius: 10))
                    }
                }
            }.padding(.horizontal, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                horizontalCards
            }
            ScrollView(.horizontal, showsIndicators: false) {
                calendarSection
            }
            
        }
    }
    private var horizontalCards: some View {
        LazyHStack {
            ForEach(filteredOrdersForToday, id: \.id) { order in
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
    private var calendarSection: some View {
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
                            ForEach(filteredOrdersByDate.keys.sorted(), id: \.self) { date in
                                ForEach(filteredOrdersByDate[date]!, id: \.date) { index in
                                    if viewModel.formattedDate(date: day, format: "dd, MMMM") == viewModel.formattedDate(date: index.date, format: "dd, MMMM") {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(height: 6)
                                    }
                                }
                            }
                            ForEach(filteredOrdersForToday, id: \.date) { item in
                                if viewModel.formattedDate(date: day, format: "dd, MMMM") == viewModel.formattedDate(date: item.date, format: "dd, MMMM") {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(height: 6)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                .frame(width: 50, height: 100)
                .background(
                    
                    // MARK: Проверить почему не получается выделить текущий день
                    
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
                    }
                }
            }
        }
        .padding()
    }
    private var verticalCards: some View {
        VStack(alignment: .center) {
            ForEach(filteredOrdersByDate.keys.sorted(), id: \.self) { date in
                Section(header: Text(date, style: .date)
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray3.name))) {
                        ForEach(filteredOrdersByDate[date]!, id: \.date) { order in
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
        MainScreenView(with: mockModel, showSignInView: .constant(true), showEditOrderView: .constant(true), showAddOrderView: .constant(false))
    }
}
private class MockViewModel: MainScreenViewModelType, ObservableObject {
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
                                                                                  imageUrl: []))]
    
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
