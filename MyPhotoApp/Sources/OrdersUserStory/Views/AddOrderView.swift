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
                            VStack(spacing: 0){
                                MainTextField(nameTextField: "Client Name", text: $viewModel.name)
                                MainTextField(nameTextField: "Location", text: $viewModel.place)
                                MainTextField(nameTextField: "Instagram Link", text: $viewModel.instagramLink)
                                MainTextField(nameTextField: "Description", text: $viewModel.description)
                                MainTextField(nameTextField: "Duration", text: $viewModel.duration)
                                    .keyboardType (.decimalPad)
                                
                                DatePicker("Chosee Data", selection: $viewModel.date).datePickerStyle(.graphical)
                            }
                            Spacer()
                            ButtonXl(titleText: "Add Order", iconName: "") {
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
        .navigationTitle("New Order")
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
    @Published var price: Int = 0
    @Published var place: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: String = ""
    @Published var imageUrl: [String] = []
    
    func addOrder(order: UserOrdersModel) async throws {
        //
    }
}
