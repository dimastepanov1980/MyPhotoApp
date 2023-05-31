//
//  AddOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/31/23.
//

import SwiftUI

@MainActor
protocol AddOrderViewModelType: ObservableObject {
    var name: String { get set }
    var instagramLink: String? { get set }
    var price: Int? { get set }
    var place: String { get set }
    var description: String? { get set }
    var date: Date? { get set }
    var duration: Double? { get set }
    
    func addOrder(location: String, customerName: String) async throws
}

@MainActor
final class AddOrderViewModel: AddOrderViewModelType {
    @Published var name: String = ""
    @Published var instagramLink: String? = nil
    @Published var price: Int? = nil
    @Published var place: String = ""
    @Published var description: String? = nil
    @Published var date: Date? = nil
    @Published var duration: Double? = nil
    
    func addOrder(location: String, customerName: String) async throws {
                let authDateResult = try AuthNetworkService.shared.getAuthenticationUser()
                try? await UserManager.shared.addUserOrder(userId: authDateResult.uid, location: location, customerName: customerName)
   
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
                            Spacer()
                            ButtonXl(titleText: "Add Order", iconName: "") {
                                if !viewModel.name.isEmpty, !viewModel.place.isEmpty {
                                    try await viewModel.addOrder(location: viewModel.place, customerName: viewModel.name)
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
    @Published var instagramLink: String? = nil
    @Published var price: Int? = nil
    @Published var place: String = ""
    @Published var description: String? = nil
    @Published var date: Date? = nil
    @Published var duration: Double? = nil
    
    func addOrder(location: String, customerName: String) async throws {
        //
    }
}
