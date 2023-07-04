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
    @Binding var showAddOrderView: Bool
    
    var filteredOrdersForToday: [UserOrdersModel] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        return viewModel.orders.filter { order in
            let formattedOrderDate = dateFormatter.string(from: order.date ?? Date())
            let formattedToday = dateFormatter.string(from: today)
            return formattedOrderDate == formattedToday
        }
    }
    var filteredOrdersForDate: [Date : [UserOrdersModel]] {
        var dictionaryByMonth = [Date : [UserOrdersModel]]()
        for order in viewModel.orders {
            if let date = order.date, date > Date() {
                let orderDate = Calendar.current.startOfDay(for: date)
                if dictionaryByMonth[orderDate] == nil {
                    dictionaryByMonth[orderDate] = [order]
                } else {
                    dictionaryByMonth[orderDate]?.append(order)
                }
            }
        }
        return dictionaryByMonth
    }
    var weatherByDate: [Date: [Weather]] {
        var weather = [Date: [Weather]]()

        if let dailyArray = viewModel.weather?.daily {
            for dailyWeather in dailyArray {
                let date = dailyWeather.dt
                print("Print weather By Date \(date)")
                if let existingWeather = weather[date] {
                    weather[date] = existingWeather + dailyWeather.weather
                } else {
                    weather[date] = dailyWeather.weather
                }
            }
        }

        return weather
    }
    var dateFormatter: DateFormatter {
     let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>,
         showAddOrderView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
        self._showAddOrderView = showAddOrderView
    }
    
    var body: some View {
        VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders, .sectionFooters]) {
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
            
            ButtonXl(titleText: R.string.localizable.takeAPhoto(), iconName: "camera.aperture") {
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
                try? await viewModel.fetchCurrentWeather(lat: "7.837090", lon: "98.294619", exclude: "current,minutely,hourly,alerts")
            }
        }
        
        .fullScreenCover(isPresented: $showAddOrderView) {
            NavigationStack {
                AddOrderView(with: AddOrderViewModel(), showAddOrderView: $showAddOrderView)
            }
        }
    }
    
    var headerSection: some View {
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
                        Image(R.image.ic_weater.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32)
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
    var horizontalCards: some View {
        LazyHStack {
            ForEach(filteredOrdersForToday, id: \.id) { order in
                NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order))
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
    var calendarSection: some View {
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
                        Circle()
                            .fill(Color(R.color.gray4.name))
                            .frame(height: 6)
                    }
                    .padding(.bottom, 16)
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
    
    var verticalCards: some View {
       VStack {
           ForEach(filteredOrdersForDate.keys.sorted(), id: \.self) { date in
               Section(header: Text(date, style: .date)) {
                   ForEach(filteredOrdersForDate[date]!, id: \.date) { order in
                       NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order))
                        .navigationBarBackButtonHidden(true)
                       ) {
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
        MainScreenView(with: mockModel, showSignInView: .constant(true), showAddOrderView: .constant(true))
    }
}

private class MockViewModel: MainScreenViewModelType, ObservableObject {
    var weatherByDate = [Date : [Weather?]]()
    
    var vm = MainScreenViewModel()
    
    @Published var weather: WeatherModel? = nil
    @Published var weaterId: String = ""
    @Published var orders: [UserOrdersModel] = [UserOrdersModel(order:
                                                        MainOrderModel(id: UUID().uuidString,
                                                                       name: "Ira",
                                                                       instagramLink: nil,
                                                                       place: "Kata Noy Beach",
                                                                       price: "5500",
                                                                       date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                                                                       duration: "1.5",
                                                                       description: nil,
                                                                       imageUrl: []))]
    @Published var selectedDay: Date = Date()
    @Published var today: Date = Date()
    
    init() {
       
    }
    
    func fetchCurrentWeather(lat: String, lon: String, exclude: String) async throws {
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
