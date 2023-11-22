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
    @Binding var path: NavigationPath

    init(with viewModel: ViewModel,
         showOrderConfirm: Binding<Bool>,
         path: Binding<NavigationPath>
    ) {
        self.viewModel = viewModel
        self._showOrderConfirm = showOrderConfirm
        self._path = path
    }
    var body: some View {
            HStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 12){
                                authorSection
                                locationSection
                                dateSection
                                priceSection
                                    .padding(.bottom, 24)
                            }
                        customerSection
                        messageSection
                        Spacer()
                    }
                    .padding(.top)
                    
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal, 24)
                .safeAreaInset(edge: .bottom) {
                    let customerIsFilled = !viewModel.customerFirstName.isEmpty && !viewModel.customerSecondName.isEmpty &&
                    !viewModel.customerInstagramLink.isEmpty && !viewModel.customerPhone.isEmpty
                    
                    CustomButtonXl(titleText: customerIsFilled ? R.string.localizable.place_order() : R.string.localizable.signup_to_continue(), iconName: "camera.on.rectangle") {
                        self.viewModel.orderDescription = orderDescription
                        if customerIsFilled {
                            Task{
                                try await viewModel.createNewOrder()
                                self.viewModel.showAlertOrderStatus = true
                            }
                        }
                    }
                    .disabled(!customerIsFilled)
                    .opacity(!customerIsFilled ? 0.5 : 1)
                }
                .overlay(alignment: .topTrailing) {
                    
                    Button {
                        showOrderConfirm = false
                        
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white, Color(R.color.gray3.name))
                            .font(.largeTitle)
                            .padding(.trailing)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showAuthenticationCustomerView) {
                    AuthenticationCustomerView(with: AuthenticationCustomerViewModel(showAuthenticationCustomerView: $viewModel.showAuthenticationCustomerView, userIsCustomer: .constant(true)), path: $path)
            }
            .onChange(of: viewModel.showAuthenticationCustomerView) { _ in
                Task{
                    try await viewModel.getCustomerData()
                }
            }
            .fullScreenCover(isPresented: $viewModel.showAlertOrderStatus) {
                CustomerStatusOrderScreenView(title: R.string.localizable.order_created(),
                                              message: R.string.localizable.order_created_message(),
                                              buttonTitle: R.string.localizable.order_created_button()) {
                    path.removeLast()
                    self.viewModel.showAlertOrderStatus = false
                    
                }
            }
    }
    
    private var customerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(R.string.localizable.about_customer())
                .font(.title2.bold())
                .foregroundColor(Color(R.color.gray2.name))
            
            textField(fieldName: R.string.localizable.settings_section_profile_firstName(), propertyName: $viewModel.customerFirstName)
            textField(fieldName: R.string.localizable.settings_section_profile_lastName(), propertyName: $viewModel.customerSecondName)
            textField(fieldName: R.string.localizable.settings_section_profile_instagram(), propertyName: $viewModel.customerInstagramLink)
            textField(fieldName: R.string.localizable.settings_section_profile_phone(), propertyName: $viewModel.customerPhone)
            textField(fieldName: R.string.localizable.settings_section_profile_email(), propertyName: $viewModel.customerEmail)
                .disabled(true)
            
            
        }
    }
    private var authorSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.photographer())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.authorName) \(viewModel.authorSecondName)")
                .font(.title2.bold())
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var locationSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.location())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.location)")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var dateSection: some View {
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
    private var priceSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.total_price())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.orderPrice)\(viewModel.currencySymbol(for: viewModel.regionAuthor))")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var messageSection: some View {
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
    private func textField(fieldName: String, propertyName: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4){
            Text(fieldName)
                .font(.caption)
                .foregroundColor(Color(R.color.gray4.name))
//                .padding(.horizontal)
            
            TextEditor(text: propertyName)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
                .padding(.horizontal)
                .frame(height: 36)
                .padding(.vertical, 2)
                .overlay{
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1)}
        }

    }
}


struct CustomerConfirmOrderView_Previews: PreviewProvider {
    @State var orderDescription: String = "$orderDescription"
    
    private static let mocItems = MockViewModel()

    static var previews: some View {
        CustomerConfirmOrderView(with: mocItems, showOrderConfirm: .constant(false), path: .constant(NavigationPath()))
    }
}

private class MockViewModel: CustomerConfirmOrderViewModelType, ObservableObject {
    var showAuthenticationCustomerView: Bool = false
    var showAlertOrderStatus: Bool = false
    
    var authorBookingDays: [String : [String]] = [:]
    var user: DBUserModel? = nil
    var customerFirstName: String = "customerName"
    var customerSecondName: String = "customerSecondName"
    var customerInstagramLink: String = "customerInstagramLink"
    var customerPhone: String = "+7 999 99 99"
    var customerEmail: String = "test@test.com"
    
    func createNewOrder() async throws {}
    func currencySymbol(for regionCode: String) -> String { "" }
    func getCustomerData() async throws {}
    var orderPrice: String = "5500"
    var authorName: String = "Iryna"
    var authorSecondName: String = "Tondaeva"
    var location: String = "Thailand"
    var orderDate: Date = Date()
    var orderTime: [String] = ["08:00", "09:00"]
    var orderDuration: String = "2"
    var orderDescription: String? = ""
    var regionAuthor: String = ""
    
    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
}
