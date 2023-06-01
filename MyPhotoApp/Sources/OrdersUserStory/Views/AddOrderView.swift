//
//  AddOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/31/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
protocol AddOrderViewModelType: ObservableObject {
    var name: String { get set }
    var instagramLink: String { get set }
    var price: Int { get set }
    var place: String { get set }
    var description: String { get set }
    var date: Date { get set }
    var duration: Double { get set }
    
    func addOrder(order: UserOrders) async throws
}

@MainActor
final class AddOrderViewModel: AddOrderViewModelType {
    @Published var name: String = ""
    @Published var instagramLink: String = ""
    @Published var price: Int = 0
    @Published var place: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var duration: Double = 0.0
    
//    init(order: OrderModel){
//        self.name = order.name ?? ""
//        self.instagramLink = order.instagramLink ?? ""
//        self.price = order.price ?? 0
//        self.place = order.location ?? ""
//        self.description = order.description ?? ""
//        self.date = order.date
//        self.duration = order.duration
//    }
    
    func addOrder(order: UserOrders) async throws {
                let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
        try? await UserManager.shared.addNewOrder(userId: authDateResult.uid, order: order)
   
    }

}



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
                        VStack(spacing: 10) {
                            MainTextField(nameTextField: "Client Name", text: $viewModel.name)
                            MainTextField(nameTextField: "Location", text: $viewModel.place)
                            MainTextField(nameTextField: "Instagram Link", text: $viewModel.instagramLink)
                            MainTextField(nameTextField: "Description", text: $viewModel.description)
                            Spacer()
                            ButtonXl(titleText: "Add Order", iconName: "") {
                                if !viewModel.name.isEmpty, !viewModel.place.isEmpty {
                                    let userOrders = UserOrders(order: OrderModel(orderId: UUID().uuidString,
                                                                                  name: viewModel.name,
                                                                                  instagramLink: viewModel.instagramLink,
                                                                                  price: viewModel.price,
                                                                                  location: viewModel.place,
                                                                                  description: viewModel.description,
                                                                                  date: viewModel.date,
                                                                                  duration: viewModel.duration, imageUrl: viewModel.name))
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
    @Published var duration: Double = 0.0
    
    func addOrder(order: UserOrders) async throws {
        //
    }
}
