//
//  CustomerOrdersView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import SwiftUI

struct CustomerOrdersView: View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var viewModel: CustomerOrdersViewModel
    @EnvironmentObject var user: UserTypeService
    
    @State var showDetailView = false
    @State var showEditOrderView = false
    
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
                ForEach(viewModel.orders.indices, id: \.self) { index in
                    CustomerOrderCellView(items: CellOrderModel(order: viewModel.orders[index]),
                                          action: { router.push(.CustomerDetailOrderView(index: index)) })
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
            CustomerOrdersView()
                .environmentObject(UserTypeService())
                .environmentObject(CustomerOrdersViewModel())
        }
    }
}

private class MockViewModel: CustomerOrdersViewModelType, ObservableObject {
    var newMessagesCount: Int = 0
    
    var getMessages: [String : [MessageModel]]?
    func orderStausColor(order: String?) -> Color {
        Color.brown
    }
    func orderStausName(status: String?) -> String {
        "Upcoming"
    }
    var orders: [OrderModel] = [OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Umpcoming", orderShootingDate: Date(), orderShootingTime: ["11:30"], orderShootingDuration: "2", orderSamplePhotos: [""], orderMessages: true, newMessagesAuthor: 0, newMessagesCustomer: 0, authorId: "", authorName: "Author", authorSecondName: "SecondName", authorLocation: "Phuket, Thailand", customerId: "", customerName: "customerName", customerSecondName: "customerSecondName", customerDescription: "Customer Description and Bla bla bla", customerContactInfo: ContactInfo(instagramLink: "", phone: "", email: ""))]
    
    func subscribe() async throws {}
}
