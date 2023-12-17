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
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    var mode: Constants.OrderMode
    
    init(with viewModel: ViewModel,
         mode: Constants.OrderMode) {
        self.viewModel = viewModel
        self.mode = mode
    }
    
    var body: some View {
        VStack {
            ScrollView {
                    VStack(alignment: .leading, spacing: 20){
                        customerSection
                            .padding(.top)
                
                        if mode == .new {
                            Text(R.string.localizable.order_shooting_details())
                                .foregroundStyle(Color(R.color.gray1.name))
                                .font(.title2.bold())
                                .padding(.horizontal)
                            datePicker
                            CustomTextField(nameTextField: R.string.localizable.order_duration(), text: $viewModel.duration, isDisabled: false)
                                .keyboardType (.decimalPad)
                            
                            CustomTextField(nameTextField: R.string.localizable.order_location(), text: $viewModel.location, isDisabled: false)
                            CustomTextField(nameTextField: R.string.localizable.order_price(), text: $viewModel.price, isDisabled: false)
                                .keyboardType (.decimalPad)
                        
                        }
                        descriptionField(fieldName: R.string.localizable.order_description(), propertyName: $viewModel.description)

                        
                    }
                }
            
        CustomButtonXl(titleText: mode == .new ? R.string.localizable.order_add_order() : R.string.localizable.order_save_order(), iconName: "") {
                let userOrders = DbOrderModel(order:
                                                OrderModel(orderId: UUID().uuidString,
                                                           orderCreateDate: Date(),
                                                           orderPrice: viewModel.price,
                                                           orderStatus: viewModel.status,
                                                           orderShootingDate: viewModel.date,
                                                           orderShootingTime: [],
                                                           orderShootingDuration: viewModel.duration,
                                                           orderSamplePhotos: viewModel.imageUrl,
                                                           orderMessages: nil,
                                                           authorId: viewModel.authorId,
                                                           authorName: nil,
                                                           authorSecondName: nil,
                                                           authorLocation: viewModel.location,
                                                           customerId: nil,
                                                           customerName: viewModel.name,
                                                           customerSecondName: viewModel.secondName,
                                                           customerDescription: viewModel.description,
                                                           customerContactInfo: DbContactInfo(instagramLink: viewModel.instagramLink,
                                                                                              phone: viewModel.phone,
                                                                                              email: viewModel.email)))
                mode == .new ? try await viewModel.addOrder(order: userOrders) : try? await viewModel.updateOrder(orderModel: userOrders)
                    router.pop()
            }
        .padding(.horizontal)
        }
        .navigationTitle(mode == .new ? R.string.localizable.order_new_order() : R.string.localizable.order_edit_order())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
    }
    
    private var customBackButton : some View {
        Button {
            router.pop()
        } label: {
            Image(systemName: "chevron.left.circle.fill")// set image here
               .font(.title)
               .foregroundStyle(Color(.systemBackground), Color(R.color.gray1.name).opacity(0.7))
        }
    }
    private var datePicker: some View{
        VStack{
            DatePicker(R.string.localizable.order_selectDate(), selection: $viewModel.date)
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
        VStack(alignment: .leading, spacing: 20) {
            CustomTextField(nameTextField: R.string.localizable.order_client_firstName(), text: $viewModel.name, isDisabled: mode == .edit)
                .disabled(mode == .edit)
            CustomTextField(nameTextField: R.string.localizable.order_client_secondName(), text: $viewModel.secondName, isDisabled: mode == .edit)
                .disabled(mode == .edit)

            CustomTextField(nameTextField: R.string.localizable.order_instagramLink(), text: $viewModel.instagramLink, isDisabled: false)
            CustomTextField(nameTextField: R.string.localizable.settings_section_profile_phone(), text: $viewModel.phone, isDisabled: false)
            CustomTextField(nameTextField: R.string.localizable.settings_section_profile_email(), text: $viewModel.email, isDisabled: mode == .edit)
                .disabled(mode == .edit)

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
            AuthorAddOrderView(with: mockModel, mode: .edit)
        }
    }
}
private class MockViewModel: AuthorAddOrderViewModelType, ObservableObject {
    @Published var status: String = ""
    @Published var name: String = ""
    @Published var secondName: String = ""
    
    @Published var instagramLink: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    
    @Published var authorId: String = ""
    @Published var price: String = ""
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    var order: DbOrderModel = DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Upcoming", orderShootingDate: Date(), orderShootingTime: ["11:00"], orderShootingDuration: "2", orderSamplePhotos: [], orderMessages: [], authorId: "", authorName: "Dimas", authorSecondName: "Tester", authorLocation: "Phuket", authorRegion: "TH", customerId: "", customerName: "Client", customerSecondName: "FamiltName", customerDescription: "SuperPUPER", customerContactInfo: DbContactInfo(instagramLink: "NEW ONE", phone: "222 22 22", email: "TEST@TEST.COM")))
 
    
    func addOrder(order: DbOrderModel) async throws {}
    func updateOrder(orderModel: DbOrderModel) async throws {}
    func updatePreview() {}
}

