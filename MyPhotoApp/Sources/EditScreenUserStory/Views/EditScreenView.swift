//
//  EditScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/16/23.
//

import SwiftUI

struct EditScreenView<ViewModel: MainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    @Namespace var animation
    @Binding var showSignInView: Bool
    @Binding var showEditOrderView: Bool
    @Binding var showAddOrderView: Bool
    @State var showActionSheet: Bool = false
    @State private var shouldScroll = false

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
        VStack {
            ScrollViewReader { data in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(pinnedViews: [.sectionHeaders, .sectionFooters]) {
                        Section {
                            ScrollView(.vertical) {
                                verticalCards()
                                    .padding(.bottom)
                                    .padding(.top, 64)
                            }
                        }
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
    func verticalCards() -> some View {
        VStack(alignment: .center) {
            ForEach(viewModel.filteredUpcomingOrders.keys.sorted(), id: \.self) { date in
                Section(header: Text(date, style: .date)
                    .id(viewModel.formattedDate(date: date, format: "dd MMMM YYYY" ))
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray3.name))) {
                        ForEach(viewModel.filteredUpcomingOrders[date]!, id: \.date) { order in
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

struct EditScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    static var previews: some View {
        EditScreenView(with: mockModel, showSignInView: .constant(true), showEditOrderView: .constant(true), showAddOrderView: .constant(false))
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
