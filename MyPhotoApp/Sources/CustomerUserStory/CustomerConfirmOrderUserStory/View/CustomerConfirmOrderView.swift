//
//  CustomerConfirmOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/28/23.
//

import SwiftUI

struct CustomerConfirmOrderView<ViewModel: CustomerConfirmOrderViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var orderDescription: String = R.string.localizable.default_message()
    @Binding var showOrderConfirm: Bool

    init(with viewModel: ViewModel,
         showOrderConfirm: Binding<Bool>) {
        self.viewModel = viewModel
        self._showOrderConfirm = showOrderConfirm
    }
    var body: some View {
        HStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    authorSection
                    locationSection
                    dateSection
                    priceSection
                    messageSection
                    Spacer()
                }.padding(.top, 80)
            }
            .safeAreaInset(edge: .bottom) {
                CustomButtonXl(titleText: "Place Order", iconName: "") {
                    //
                }
            }
                .overlay(alignment: .topTrailing) {
                    
                    Button {
                        showOrderConfirm.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(R.color.gray3.name).opacity(0.5))
                    }
                }
            
            Spacer()
        }.padding(.horizontal, 24)
    }
    
    var authorSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.photographer())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text(viewModel.authorName)
                .font(.title2.bold())
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    
    var locationSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.location())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.authorCity), \(viewModel.authorRegion)")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    var dateSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.date_detail())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            HStack (spacing: 12) {
                HStack(spacing: 2) {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray1.name))
                    Text(viewModel.formattedDate(date: viewModel.orderDate, format: "dd MMMM"))
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
                if let time = viewModel.sortedDate(array: viewModel.orderTime).first{
                    HStack(spacing: 2){
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray1.name))
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray3.name))
                    }
                }
                HStack(spacing: 2){
                    Image(systemName: "timer")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray1.name))
                    Text("\(viewModel.orderDuration)")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
            }
        }
    }
    var priceSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.total_price())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text(viewModel.orderPrice)
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    var messageSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.message())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
               
            TextEditor(text: $orderDescription)
                .font(.body)
                .foregroundColor(orderDescription == R.string.localizable.default_message() ? Color(R.color.gray4.name) : Color(R.color.gray2.name))
                .frame(height: 250)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(R.color.gray4.name) ,lineWidth: 0.5)
                }
                .onTapGesture {
                    if orderDescription == R.string.localizable.default_message() {
                        self.orderDescription = ""
                    }
                }
        }
    }


}

struct CustomHeightTextField: View {
    @Binding var text: String
    let axis: Axis

    var body: some View {
        TextEditor(text: $text)
            .lineSpacing(5) // Adjust line spacing if desired
            .frame(minHeight: axis == .vertical ? 100 : 50) // Set your desired height
            .font(.body)
            .textFieldStyle(.roundedBorder)
            .lineLimit(5)
            .foregroundColor(Color.red)
    }
}

struct CustomerConfirmOrderView_Previews: PreviewProvider {
    @State var orderDescription: String = "$orderDescription"
    
    private static let mocItems = MockViewModel()

    static var previews: some View {
        CustomerConfirmOrderView(with: mocItems, showOrderConfirm: .constant(false))
    }
}

private class MockViewModel: CustomerConfirmOrderViewModelType, ObservableObject {
    @Published var orderPrice: String = "5500"
    @Published var authorName: String = "Iryna"
    @Published var familynameAuthor: String = "Tondaeva"
    @Published var authorRegion: String = "Thailand"
    @Published var authorCity: String = "Phuket"
    @Published var orderDate: Date = Date()
    @Published var orderTime: [String] = ["08:00", "09:00"]
    @Published var orderDuration: String = "2"
    @State var orderDescription: String = ""
  
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
}
