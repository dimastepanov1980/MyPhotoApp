//
//  AuthorAddOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/31/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AuthorAddOrderView<ViewModel: AuthorAddOrderViewModelType>: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var showAddOrderView: Bool
    var mode: Mode
    
    init(with viewModel: ViewModel,
         showAddOrderView: Binding<Bool>,
         mode: Mode) {
        self.viewModel = viewModel
        self._showAddOrderView = showAddOrderView
        self.mode = mode
    }
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20){
                        customerSection
                        
                        if mode == .new {
                            Text("Shooting details")
                                .foregroundStyle(Color(R.color.gray1.name))
                                .font(.title2.bold())
                                .padding(.horizontal)
                            datePicker
                            CustomTextField(nameTextField: R.string.localizable.order_Duration(), text: $viewModel.duration)
                                .keyboardType (.decimalPad)
                            
                            CustomTextField(nameTextField: R.string.localizable.order_Location(), text: $viewModel.location)
                            CustomTextField(nameTextField: R.string.localizable.order_Price(), text: $viewModel.price)
                                .keyboardType (.decimalPad)
                        
                        }
                        descriptionField(fieldName: R.string.localizable.order_Description(), propertyName: $viewModel.description)

                        
                    }
                }
            }
            
        CustomButtonXl(titleText: mode == .new ? R.string.localizable.order_AddOrder() : R.string.localizable.order_SaveOrder(), iconName: "") {
                let userOrders = DbOrderModel(order: OrderModel(orderId: UUID().uuidString, orderCreateDate: Date(), orderPrice: viewModel.price, orderStatus: viewModel.status, orderShootingDate: viewModel.date, orderShootingTime: [], orderShootingDuration: viewModel.duration, orderSamplePhotos: viewModel.imageUrl, orderMessages: nil, authorId: nil, authorName: nil, authorSecondName: nil, authorLocation: viewModel.location,  customerId: nil, customerName: nil, customerSecondName: nil, customerDescription: viewModel.description, customerContactInfo: DbContactInfo(instagramLink: viewModel.instagramLink, phone: nil, email: nil)))
                mode == .new ? try await viewModel.addOrder(order: userOrders) : try? await viewModel.updateOrder(orderModel: userOrders)
                    showAddOrderView.toggle()
            }
            //.disabled(viewModel.modified)
        }
        .navigationTitle(mode == .new ? R.string.localizable.order_NewOrder() : R.string.localizable.order_EditOrder())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddOrderView.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white, Color(R.color.gray3.name))
                        .font(.title2)
                        .padding(.trailing)
                }
            }
        }
    }
    private var datePicker: some View{
        VStack{
            DatePicker(R.string.localizable.order_SelectDate(), selection: $viewModel.date)
                .datePickerStyle(.compact)
                .accentColor(Color(R.color.gray2.name))
                .frame(height: 42)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1))
                .padding(.bottom, 8)
                .padding(.horizontal)
                .foregroundColor(Color(R.color.gray4.name))
        }
    }
    private var customerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            textField(fieldName: R.string.localizable.order_firstName(), propertyName: $viewModel.name)
            textField(fieldName: R.string.localizable.order_secondName(), propertyName: $viewModel.secondName)
            textField(fieldName: R.string.localizable.settings_section_profile_instagram(), propertyName: $viewModel.instagramLink)
                textField(fieldName: R.string.localizable.settings_section_profile_phone(), propertyName: $viewModel.phone)
                textField(fieldName: R.string.localizable.settings_section_profile_email(), propertyName: $viewModel.email)
            
            
        }
        .padding(.horizontal)
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
    private func descriptionField(fieldName: String, propertyName: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4){
            Text(fieldName)
                .font(.caption)
                .foregroundColor(Color(R.color.gray4.name))
            
            TextEditor(text: propertyName)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
                .padding(.horizontal)
                .frame(height: 170)
                .padding(.vertical, 2)
                .overlay{
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1)}
        }                .padding(.horizontal)


    }

}

struct AuthorAddOrderView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        NavigationView {
            AuthorAddOrderView(with: mockModel, showAddOrderView: .constant(true), mode: .edit)
        }
    }
}
private class MockViewModel: AuthorAddOrderViewModelType, ObservableObject {
    var phone: String = ""
    var email: String = ""
    var secondName: String = ""
    var avaibleStatus = [""]
    var status: String = ""
    var name: String = ""
    var instagramLink: String = ""
    var price: String = ""
    var location: String = ""
    var description: String = ""
    var date = Date()
    var duration: String = ""
    var imageUrl: [String]  = []
    
    var order: DbOrderModel = DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Upcoming", orderShootingDate: Date(), orderShootingTime: ["11:00"], orderShootingDuration: "2", orderSamplePhotos: [], orderMessages: [], authorId: "", authorName: "Dimas", authorSecondName: "Tester", authorLocation: "Phuket", authorRegion: "TH", customerId: "", customerName: "Client", customerSecondName: "FamiltName", customerDescription: "SuperPUPER", customerContactInfo: DbContactInfo(instagramLink: "NEW ONE", phone: "222 22 22", email: "TEST@TEST.COM")))
 
    
    func addOrder(order: DbOrderModel) async throws {}
    func updateOrder(orderModel: DbOrderModel) async throws {}
    func updatePreview() {}
}

