//
//  MainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/21/23.
//

import SwiftUI

struct MainScreenView<ViewModel: MainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    
    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            dayAvatarSection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    horizontalCards
                }
            }.padding(.horizontal, 8)
            
            ScrollView(showsIndicators: false) {
                    verticalCards
            }.padding(.horizontal, 8)
        }
    }
    
    var dayAvatarSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(R.string.localizable.today())
                    .font(.subheadline.bold())
                    .foregroundColor(Color(R.color.gray3.name))
                
                HStack {
                    Text(viewModel.formattedDate(date: Date()))
                        .font(.title.bold())
                        .foregroundColor(Color(R.color.gray1.name))
// TODO: Обработка погоды
                    Image(R.image.ic_weater.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                }
            }
            Spacer()
            Button {
                //
            } label: {
                Image(R.image.image0.name)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56)
                    .overlay(Circle().stroke(Color.white,lineWidth: 2).shadow(radius: 10))
            }
        }.padding(.horizontal, 32)
    }
    
    var horizontalCards: some View {
        ForEach(viewModel.orders) { card in
            HCellMainScreenView(items: card)
        }
    }
    
    var verticalCards: some View {
        ForEach(viewModel.orders) { card in
            VCellMainScreenView(items: card)
        }
    }
    
}
    
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
        MainScreenView(with: mockModel)
    }
}

private class MockViewModel: MainScreenViewModelType, ObservableObject {
    @Published var userId: String = ""
    @Published var name: String =  ""
    @Published var place: String?
    @Published var date: Date = Date()
    @Published var duration: Double = 0.0
    @Published var imageUrl: String = ""
    @Published var weaterId: String = ""
    @Published var orders: [MainOrderModel] = [
        MainOrderModel(userId: "",
                       name: "Ira",
                       place: "Kata Noy Beach",
                       date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                       duration: 1.5,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Olga",
                       place: "Surin Beach",
                       date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date(),
                       duration: 2.0,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Vika",
                       place: "Kata Beach",
                       date: Date(),
                       duration: 1.5,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Dasha",
                       place: "Nai Ton Long Beach",
                       date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date(),
                       duration: 1.0,
                       imageUrl: ""),
        MainOrderModel(userId: "",
                       name: "Nastiy",
                       place: "Kamala Beach",
                       date: Calendar.current.date(byAdding: .day, value: +5, to: Date()) ?? Date(),
                       duration: 1.5,
                       imageUrl: "")
    ]

    
    func createOrder() {
        //
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM" // Set the desired output date format
        return dateFormatter.string(from: date)
    }
}
