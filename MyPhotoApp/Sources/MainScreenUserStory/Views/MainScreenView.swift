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
    
    init(with viewModel: ViewModel,
         showSignInView: Binding<Bool>,
         showAddOrderView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showSignInView = showSignInView
        self._showAddOrderView = showAddOrderView
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders, .sectionFooters]) {
                        Section {
                            ScrollView(.vertical) {
                                verticalCards
                            }
                            //MARK: Calendar
                            
                        } header: {
                            headerSection
                                .padding(.top, 64)
                        } .background()
                    }
                }.edgesIgnoringSafeArea(.bottom)
                    .ignoresSafeArea()
                    .padding(.bottom)
            
            ButtonXl(titleText: R.string.localizable.takeAPhoto(), iconName: "camera.aperture") {
                
                try? await viewModel.loadOrders()
                showAddOrderView.toggle()
                
            }.background()
        } .onChange(of: showAddOrderView, perform: { _ in
            Task{
                try? await viewModel.loadOrders()
            }
        })
        .task {
            try? await viewModel.loadOrders()
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
                        Text(viewModel.formattedDate(date: viewModel.today))
                            .font(.title.bold())
                            .foregroundColor(Color(R.color.gray1.name))
                        //    ToDo: need to updete date avery time then we lunch app - this method do it not coorect -
                        //                            .onAppear {
                        //                                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        //                                    viewModel.today = Date()
                        //                                }
                        //                            }
                        
                        // TODO: Обработка погоды
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
            ForEach(viewModel.orders, id: \.id) { order in
                NavigationLink(destination: DetailOrderView(with: DetailOrderViewModel(order: order))
                    .navigationBarBackButtonHidden(true)) {
                    HCellMainScreenView(items: order)
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
            
        }  .padding(.horizontal)
    }
    var calendarSection: some View {
        HStack(spacing: 8){
            ForEach(viewModel.currentWeek, id: \.self) { day in
                VStack(spacing: 4) {
                    Image(systemName: "cloud.sun.rain")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(R.color.gray3.name))
                    
                    Text(viewModel.extractDate(date: day, format: "dd"))
                        .font(.body.bold())
                        .foregroundColor(Color(R.color.gray2.name))
                    
                    Text(viewModel.extractDate(date: day, format: "EEE"))
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray3.name))
                    
                    Circle()
                        .fill(Color(R.color.gray4.name))
                        .frame(height: 6)
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
                        viewModel.currentDay = day
                    }
                }
            }
        }
        .padding()
    }
    var verticalCards: some View {
        LazyVStack {
            ForEach(viewModel.orders, id: \.id) { order in
                
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
    var vm = MainScreenViewModel()
    
    @Published var weaterId: String = ""
    @Published var orders: [UserOrdersModel] = [UserOrdersModel(order:
                                                        MainOrderModel(id: UUID().uuidString,
                                                                       name: "Ira",
                                                                       instagramLink: nil,
                                                                       place: "Kata Noy Beach",
                                                                       price: 5500,
                                                                       date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                                                                       duration: "1.5",
                                                                       description: nil,
                                                                       imageUrl: []))]
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var today: Date = Date()
    
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...14).forEach { day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekDay)
            }
        }
    }
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func formattedDate(date: Date) -> String {
        vm.formattedDate(date: date)
    }
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    func isTodayDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(today, inSameDayAs: date)
    }
    func deleteOrder(order: UserOrdersModel) async throws {
        //
    }
    func loadOrders() async throws {
        //
    }
}
