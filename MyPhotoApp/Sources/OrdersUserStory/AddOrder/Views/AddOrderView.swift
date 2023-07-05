//
//  AddOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/31/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddOrderView<ViewModel: AddOrderViewModelType>: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var showAddOrderView: Bool
    
    init(with viewModel: ViewModel,
         showAddOrderView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showAddOrderView = showAddOrderView
    }
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    orderFiels()
                    Spacer()
                    CustomButtonXl(titleText: R.string.localizable.order_AddOrder(), iconName: "") {
                        if !viewModel.name.isEmpty, !viewModel.place.isEmpty {
                            let userOrders = UserOrdersModel(order: OrderModel(orderId: UUID().uuidString,
                                                                               name: viewModel.name,
                                                                               instagramLink: viewModel.instagramLink,
                                                                               price: viewModel.price,
                                                                               location: viewModel.place,
                                                                               description: viewModel.description,
                                                                               date: viewModel.date,
                                                                               duration: viewModel.duration,
                                                                               imageUrl: viewModel.imageUrl))
                            try await viewModel.addOrder(order: userOrders)
                            showAddOrderView.toggle()
                        }
                    }
                }
            }
        }
        .navigationTitle(R.string.localizable.order_NewOrder())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddOrderView.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                }
            }
        }
    }
    
    private func orderFiels() -> some View {
        VStack(alignment: .leading, spacing: 16){
            DatePicker(R.string.localizable.order_SelectDate(), selection: $viewModel.date)
                .datePickerStyle(.compact)
                .accentColor(Color(R.color.gray2.name))
                .frame(height: 42)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray3.name), lineWidth: 1))
                .padding(.bottom, 8)
                .padding(.horizontal)
                .padding(.top, 32)
                .foregroundColor(Color(R.color.gray4.name))
            
            CustomTextField(nameTextField: R.string.localizable.order_ClientName(), text: $viewModel.name)
            CustomTextField(nameTextField: R.string.localizable.order_Location(), text: $viewModel.place)
            CustomTextField(nameTextField: R.string.localizable.order_Price(), text: $viewModel.price)
                .keyboardType (.decimalPad)
            CustomTextField(nameTextField: R.string.localizable.order_InstagramLink(), text: $viewModel.instagramLink)
            CustomTextField(nameTextField: R.string.localizable.order_Description(), text: $viewModel.description)
            CustomTextField(nameTextField: R.string.localizable.order_Duration(), text: $viewModel.duration)
                .keyboardType (.decimalPad)
        }
         
    }
}

struct AddOrderView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    
    static var previews: some View {
        NavigationView {
            AddOrderView(with: mockModel, showAddOrderView: .constant(true))
        }
    }
}


private class MockViewModel: AddOrderViewModelType, ObservableObject {
    @Published var name: String = ""
    @Published var instagramLink: String = ""
    @Published var price: String = ""
    @Published var place: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    func addOrder(order: UserOrdersModel) async throws {
        //
    }
}
