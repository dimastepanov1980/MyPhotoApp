//
//  AuthorMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/21/23.
//

import SwiftUI
import Combine
import MapKit

struct AuthorMainScreenView: View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    @EnvironmentObject var viewModel: AuthorMainScreenViewModel
    
    @State var showActionSheet: Bool = false
    @State var shouldScroll = false
    let currentDate = Date()  // Get the current date
    let calendar = Calendar.current
    
    var body: some View {
        VStack {
            ScrollViewReader { data in
                if !viewModel.authorOrders.isEmpty{
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section {
                                ScrollView(.vertical, showsIndicators: false) {
                                    verticalCards()
                                        .padding(.bottom, 42)
                                        .padding(.top, 0)
                                }
                            } header: {
                                headerSection(scroll: data)
                                    .padding(.top, 64)
                                    .padding(.bottom, 4)
                                    .background(Color(.systemBackground))
                                    .ignoresSafeArea()
                            }
                        }
                    }
                } else {
                    ZStack{
                        Color(.systemBackground)
                            .ignoresSafeArea()
                        
                        Text(R.string.localizable.order_not_found_worning())
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray3.name))
                            .padding()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(R.string.localizable.settings_name_screen())
        
        .ignoresSafeArea()
        .background(Color(.systemBackground))

    }
    func headerSection(scroll: ScrollViewProxy) -> some View {
        VStack {
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
        HStack {
            ForEach(viewModel.authorOrders.indices, id: \.self) { index in
                if calendar.isDate(viewModel.authorOrders[index].orderShootingDate, inSameDayAs: currentDate) {
                    AuthorHCellMainScreenView(items: CellOrderModel(order: viewModel.authorOrders[index])) {
                        router.push(.AuthorDetailOrderView(index: index))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    /*
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
                            ForEach(viewModel.authorOrders.indices, id: \.self) { index in
                                if calendar.compare(viewModel.authorOrders[index].orderShootingDate, to: currentDate, toGranularity: .day) == .orderedDescending {
                                    if viewModel.formattedDate(date: day, format: "dd MMMM YYYY") == viewModel.formattedDate(date: viewModel.authorOrders[index].orderShootingDate, format: "dd MMMM YYYY") {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(height: 6)
                                    }
                                    }
                                }
                            
                            ForEach(viewModel.authorOrders.indices, id: \.self) { index in
                                if calendar.isDate(viewModel.authorOrders[index].orderShootingDate, inSameDayAs: currentDate) {
                                    
                                    if viewModel.formattedDate(date: day, format: "dd MMMM YYYY") == viewModel.formattedDate(date: viewModel.authorOrders[index].orderShootingDate, format: "dd MMMM YYYY") {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(height: 6)
                                    }
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
                        }
                    }
                )
                .containerShape(Capsule())
                .onTapGesture {
                    withAnimation {
                        viewModel.selectedDay = day
                        print(viewModel.formattedDate(date: viewModel.selectedDay, format: "dd MMMM YYYY" ))
                        print("scroll to: \(viewModel.formattedDate(date: viewModel.selectedDay, format: "dd MMMM YYYY" ))")

                        // MARK: - make animation scroll
                        value.scrollTo(viewModel.formattedDate(date: viewModel.selectedDay, format: "dd MMMM YYYY" ), anchor: .bottom)
                        shouldScroll.toggle()
                    }
                }
                .onAppear{
                    print("day: \(day)")
                }
            }
        }
        .padding(.horizontal)
    }
     */
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
                            ForEach(viewModel.authorOrders.indices, id: \.self) { index in
                                if calendar.compare(viewModel.authorOrders[index].orderShootingDate, to: currentDate, toGranularity: .day) == .orderedDescending {
                                    if viewModel.formattedDate(date: day, format: "dd MMMM YYYY") == viewModel.formattedDate(date: viewModel.authorOrders[index].orderShootingDate, format: "dd MMMM YYYY") {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(height: 6)
                                    }
                                }
                            }

                            ForEach(viewModel.authorOrders.indices, id: \.self) { index in
                                if calendar.isDate(viewModel.authorOrders[index].orderShootingDate, inSameDayAs: currentDate) {

                                    if viewModel.formattedDate(date: day, format: "dd MMMM YYYY") == viewModel.formattedDate(date: viewModel.authorOrders[index].orderShootingDate, format: "dd MMMM YYYY") {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(height: 6)
                                    }
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
                        }
                    }
                )
                .containerShape(Capsule())
                .onTapGesture {
                    withAnimation {
                        viewModel.selectedDay = day
                        let formattedDate = viewModel.formattedDate(date: viewModel.selectedDay, format: "dd MMMM YYYY")
                        print("Selected day: \(formattedDate)")

                        // Ensure the ID matches the expected section ID
                        let sectionId = viewModel.formattedDate(date: day, format: "dd MMMM YYYY")
                        print("Scrolling to section: \(sectionId)")

                        // Scroll to the selected section
                        value.scrollTo(sectionId, anchor: .top)
                        shouldScroll.toggle()
                    }
                }
                .onAppear {
                    print("day: \(day)")
                }
            }
        }
        .padding(.horizontal)
    }

    func verticalCards() -> some View {
        VStack(alignment: .center) {
            ForEach(Array(viewModel.authorOrders
                            .sorted(by: { $0.orderShootingDate < $1.orderShootingDate })
                            .filter { calendar.compare($0.orderShootingDate, to: currentDate, toGranularity: .day) == .orderedDescending }
                            .reduce(into: [Date: [OrderModel]]()) { result, order in
                                let key = calendar.startOfDay(for: order.orderShootingDate)
                                result[key, default: []].append(order)
                            }
                            .sorted { $0.key < $1.key }
                            .enumerated()), id: \.1.key) { index, group in
                            
                Section(header: Text(viewModel.formattedDate(date: group.key, format: "dd MMMM YYYY" ))
                            .id(viewModel.formattedDate(date: group.key, format: "dd MMMM YYYY" ))
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray3.name))) {
                                
                    ForEach(group.value, id: \.self) { order in
                        AuthorVCellMainScreenView(items: CellOrderModel(order: order),
                                                  statusColor: viewModel.orderStausColor(order: order.orderStatus),
                                                  status: viewModel.orderStausName(status: order.orderStatus)) {
                            router.push(.AuthorDetailOrderView(index: viewModel.authorOrders.firstIndex(of: order) ?? 0))
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }

}

//struct AuthorMainScreenView_Previews: PreviewProvider {
//    private static let mockModel = MockViewModel()
//    static var previews: some View {
//        AuthorMainScreenView(with: mockModel, statusOrder: .Upcoming)
//            .environmentObject(UserTypeService())
//    }
//}
//private class MockViewModel: AuthorMainScreenViewModelType, ObservableObject {
//    func getMinimalTimeSlot(_ time: String) -> Int {
//        return 0
//    }
//    
//    var userProfileIsSet: Bool = true
//    
//    var filteredOtherOrders: [Date : [OrderModel]] = [:]
//    var filteredOrdersForToday: [OrderModel] = []
//    var filteredUpcomingOrders: [Date : [OrderModel]] = [:]
//    var vm = AuthorMainScreenViewModel()
//    var location = LocationService()
//    
//    @Published var weatherByDate = [Date : [Weather?]]()
//    @Published var weatherForCurrentDay: String? = nil
//    @Published var weaterId: String = ""
//    @Published var selectedDay: Date = Date()
//    @Published var today: Date = Date()
//    
//    init() {}
//    func fetchWeather(with location: CLLocation) {
//    }
//    
//    func getIconForWeatherCode(weatherCode: String) -> String {
//        return ""
//    }
//    
//    func orderStausName(status: String?) -> String {
//        "Upcoming"
//    }
//    func fetchWeather() async throws {
//        //
//    }
//    func orderStausColor(order: String?) -> Color {
//        return Color.gray
//    }
//    
//    func formattedDate(date: Date, format: String) -> String {
//        return ""
//    }
//    func isToday(date: Date) -> Bool {
//        return true
//    }
//    func isTodayDay(date: Date) -> Bool {
//        return true
//    }
//    func deleteOrder(order: DbOrderModel) async throws {
//        //
//    }
//}
