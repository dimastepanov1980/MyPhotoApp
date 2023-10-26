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
    
    init(with viewModel: ViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView{
            ForEach(viewModel.orders, id: \.orderId) { order in
                NavigationLink {
                    DetailOrderView(with: DetailOrderViewModel(order: order), showEditOrderView: .constant(false), detailOrderType: .customer)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    CustomerOrderCellView(items: order, statusColor: .blue)
                }
            }
        }.padding(.horizontal)
    }
}

struct CustomerOrdersView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        CustomerOrdersView(with: mockModel)
    }
}

private class MockViewModel: CustomerOrdersViewModelType, ObservableObject {
    
    var orders: [DbOrderModel] = [DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Umpcoming", orderShootingDate: Date(), orderShootingTime: ["11:30"], orderShootingDuration: "2", orderSamplePhotos: [""], orderMessages: nil, authorId: "", authorName: "Author", authorSecondName: "SecondName", authorLocation: "Phuket, Thailand", customerId: "", customerName: "customerName", customerSecondName: "customerSecondName", customerDescription: "Customer Description and Bla bla bla", customerContactInfo: DbContactInfo(instagramLink: "", phone: "", email: "")))]
    
    func getOrders() async throws {}
    
    
}
