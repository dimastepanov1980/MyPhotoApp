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
            NavigationView {
                ScrollView {
                    orderFiels()
                    Spacer()
                }
            }
            
            if mode == .edit {
                Button(R.string.localizable.order_Delete()) {
                    //
                }
            }
            
            CustomButtonXl(titleText: mode == .new ? R.string.localizable.order_AddOrder() : R.string.localizable.order_SaveOrder(), iconName: "") {
                let userOrders = DbOrderModel(order: AuthorOrderModel(orderId: UUID().uuidString,
                                                                      orderCreateDate: Date(),
                                                                      orderPrice: viewModel.price,
                                                                      orderStatus: viewModel.status,
                                                                      authorName: viewModel.name,
                                                                      authorSecondName: viewModel.secondName,
                                                                      instagramLink: viewModel.instagramLink,
                                                                      authorLocation: viewModel.location,
                                                                      description: viewModel.description,
                                                                      orderShootingDate: viewModel.date,
                                                                      orderShootingTime: [],
                                                                      orderShootingDuration: viewModel.duration,
                                                                      orderSamplePhotos: viewModel.imageUrl,
                                                                      orderMessages: nil))
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
                        .font(.title2)
                }
            }
        }
    }
    
    private func orderFiels() -> some View {
        VStack(alignment: .leading, spacing: 28){
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
            CustomTextField(nameTextField: R.string.localizable.order_Location(), text: $viewModel.location)
            CustomTextField(nameTextField: R.string.localizable.order_Price(), text: $viewModel.price)
                .keyboardType (.decimalPad)
            CustomTextField(nameTextField: R.string.localizable.order_InstagramLink(), text: $viewModel.instagramLink)
            CustomTextField(nameTextField: R.string.localizable.order_Description(), text: $viewModel.description)
            CustomTextField(nameTextField: R.string.localizable.order_Duration(), text: $viewModel.duration)
                .keyboardType (.decimalPad)
        }
         
    }
}

//struct AuthorAddOrderView_Previews: PreviewProvider {
//    private static let mockModel = MockViewModel(order: updatePreview())
//
//    static var previews: some View {
//        NavigationView {
//            AuthorAddOrderView(with: mockModel, showAddOrderView: .constant(true), mode: .edit)
//        }
//    }
//}
private class MockViewModel: AuthorAddOrderViewModelType, ObservableObject {
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
    
    var order: DbOrderModel
    init(order: DbOrderModel) {
        self.order = order
        updatePreview()
    }

    func updatePreview() {
        name = order.authorName ?? ""
        instagramLink = order.instagramLink ?? ""
        price = order.orderPrice ?? ""
        location = order.authorLocation ?? ""
        description = order.description ?? ""
        duration = order.orderShootingDuration ?? ""
        imageUrl = order.orderSamplePhotos ?? []
        date = order.orderShootingDate
        status = order.orderStatus ?? ""
    }
    
    func addOrder(order: DbOrderModel) async throws {
        //
    }
    func updateOrder(orderModel: DbOrderModel) async throws {
        //
    }
}

