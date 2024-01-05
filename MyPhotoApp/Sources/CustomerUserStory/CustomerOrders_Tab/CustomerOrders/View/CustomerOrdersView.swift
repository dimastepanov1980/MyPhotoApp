//
//  CustomerOrdersView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import SwiftUI

struct CustomerOrdersView<ViewModel: CustomerOrdersViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    
    @State var showDetailView = false
    @State var showEditOrderView = false

    init(with viewModel: ViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            orderView(userAuth: user.userType == .unspecified)
                .navigationTitle(R.string.localizable.customer_tabs_message())
                .background(Color(.systemBackground))
                .scrollContentBackground(.hidden)
                .navigationBarBackButtonHidden(true)
                .padding(.top)
                .padding(.horizontal, 8)
                .padding(.bottom, 86)
        }
    }
    
    @ViewBuilder
    private func orderView(userAuth: Bool) -> some View {
        if !userAuth {
            if viewModel.orders.isEmpty{
                VStack(alignment: .center){
                    Text(R.string.localizable.customer_orders_worning())
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray3.name))
                        .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            } else {
                ForEach(viewModel.orders.sorted(by: { $0.orderShootingDate < $1.orderShootingDate }), id: \.orderId) { order in
                    CustomerOrderCellView(items: order, statusColor: viewModel.orderStausColor(order: order.orderStatus ?? ""), status: viewModel.orderStausName(status: order.orderStatus ?? ""))
                        .onTapGesture {
                            router.push(.DetailOrderView(order: order))
                        }
                }
            }
        } else {
                SignInSignUpButton(router: _router, user: _user)
                .padding(.horizontal, 24)
        }
    }
}

struct CustomerOrdersView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        NavigationStack{
            CustomerOrdersView(with: mockModel)
                .environmentObject(UserTypeService())
        }
    }
}

private class MockViewModel: CustomerOrdersViewModelType, ObservableObject {
    func orderStausColor(order: String?) -> Color {
        Color.brown
    }
    
    func orderStausName(status: String?) -> String {
        "Upcoming"
    }
    
    
    var orders: [DbOrderModel] = [DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Umpcoming", orderShootingDate: Date(), orderShootingTime: ["11:30"], orderShootingDuration: "2", orderSamplePhotos: [""], orderMessages: true, authorId: "", authorName: "Author", authorSecondName: "SecondName", authorLocation: "Phuket, Thailand", customerId: "", customerName: "customerName", customerSecondName: "customerSecondName", customerDescription: "Customer Description and Bla bla bla", customerContactInfo: ContactInfo(instagramLink: "", phone: "", email: "")))]
    
    func subscribe() async throws {}
}
