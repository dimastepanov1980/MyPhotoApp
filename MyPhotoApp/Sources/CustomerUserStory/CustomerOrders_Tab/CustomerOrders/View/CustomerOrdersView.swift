//
//  CustomerOrdersView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/16/23.
//

import SwiftUI

struct CustomerOrdersView<ViewModel: CustomerOrdersViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var showDetailView = false
    @State var showEditOrderView = false
    @Binding var path: NavigationPath

    init(with viewModel: ViewModel,
         path: Binding<NavigationPath>){
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if viewModel.orders.isEmpty{
                Color(R.color.gray7.name)
                    .ignoresSafeArea()
                Text(R.string.localizable.customer_orders_worning())
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding()
                
            } else {
                ScrollView{
                    ForEach(viewModel.orders, id: \.orderId) { order in
                        NavigationLink(value: order) {
                            CustomerOrderCellView(items: order, statusColor: viewModel.orderStausColor(order: order.orderStatus ?? ""), status: viewModel.orderStausName(status: order.orderStatus ?? ""))
                        }
                    }
                }.padding()
            }
        }
        .navigationDestination(for: DbOrderModel.self, destination: { order in
            DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: $showEditOrderView, detailOrderType: .customer, path: $path)
           //                                .navigationBarBackButtonHidden(true)
        })
        .onAppear{
            print("CustomerOrdersView Path count: \(path.count)")
        }
        .background(Color(R.color.gray7.name))
        
    }
}

struct CustomerOrdersView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        CustomerOrdersView(with: mockModel, path: .constant(NavigationPath()))
    }
}

private class MockViewModel: CustomerOrdersViewModelType, ObservableObject {
    func orderStausColor(order: String?) -> Color {
        Color.brown
    }
    
    func orderStausName(status: String?) -> String {
        "Upcoming"
    }
    
    
    var orders: [DbOrderModel] = [DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Umpcoming", orderShootingDate: Date(), orderShootingTime: ["11:30"], orderShootingDuration: "2", orderSamplePhotos: [""], orderMessages: nil, authorId: "", authorName: "Author", authorSecondName: "SecondName", authorLocation: "Phuket, Thailand", customerId: "", customerName: "customerName", customerSecondName: "customerSecondName", customerDescription: "Customer Description and Bla bla bla", customerContactInfo: DbContactInfo(instagramLink: "", phone: "", email: "")))]
    
    func subscribe() async throws {}
}
