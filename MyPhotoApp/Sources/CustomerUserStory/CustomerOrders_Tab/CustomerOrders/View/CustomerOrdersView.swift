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
    @Binding var showAuthenticationView: Bool

    init(with viewModel: ViewModel,
         showAuthenticationView: Binding<Bool>){
        self.viewModel = viewModel
        self._showAuthenticationView = showAuthenticationView
    }
    
    var body: some View {
        VStack{
            orderView(userAuth: user.userType == .unspecified)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Text(R.string.localizable.customer_tabs_message())
                    .font(.title.bold())
                    .padding()
            }
    }

        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
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
                ScrollView{
                    ForEach(viewModel.orders, id: \.orderId) { order in
                            CustomerOrderCellView(items: order, statusColor: viewModel.orderStausColor(order: order.orderStatus ?? ""), status: viewModel.orderStausName(status: order.orderStatus ?? ""))
                            .onTapGesture {
                                router.push(.DetailOrderView(order: order))
                            }
                    }
                    .padding(.bottom, 70)
                }.scrollIndicators(.hidden)
                    .padding()
            }
        } else {
            List{
                VStack(alignment: .leading, spacing: 16){
                    Text(R.string.localizable.signin_to_continue())
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                        .padding(.bottom)
                    
                    CustomButtonXl(titleText: R.string.localizable.logIn(), iconName: "lock") {
                        showAuthenticationView = true
                    }
                    
                    Button {
                        showAuthenticationView = true
                    } label: {
                        HStack{
                            Text(R.string.localizable.signup_to_continue())
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                            Text(R.string.localizable.registration())
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                    }
                }
                
            }
//            .scrollContentBackground(.hidden)
            .tint(.black)
        }
    }
}

struct CustomerOrdersView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        CustomerOrdersView(with: mockModel, showAuthenticationView: .constant(false))
    }
}

private class MockViewModel: CustomerOrdersViewModelType, ObservableObject {
    @Published  var userIsAuth: Bool = true

    func orderStausColor(order: String?) -> Color {
        Color.brown
    }
    
    func orderStausName(status: String?) -> String {
        "Upcoming"
    }
    
    
    var orders: [DbOrderModel] = [DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Umpcoming", orderShootingDate: Date(), orderShootingTime: ["11:30"], orderShootingDuration: "2", orderSamplePhotos: [""], orderMessages: nil, authorId: "", authorName: "Author", authorSecondName: "SecondName", authorLocation: "Phuket, Thailand", customerId: "", customerName: "customerName", customerSecondName: "customerSecondName", customerDescription: "Customer Description and Bla bla bla", customerContactInfo: DbContactInfo(instagramLink: "", phone: "", email: "")))]
    
    func subscribe() async throws {}
}
