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
                CustomerOrderCellView(items: order, statusColor: .blue)
                    .onTapGesture {
                        viewModel.selectedOrder = order
                        showDetailView.toggle()
                    }

                    .fullScreenCover(isPresented: $showDetailView) {
                        if let selectedOrder = viewModel.selectedOrder {
                            CustomerDetailOrderView(with: CustomerDetailOrderViewModel(order: selectedOrder), showDetailOrderView: $showDetailView)
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        showDetailView.toggle()
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(Color(R.color.gray3.name).opacity(0.5))
                                    }
                                    .padding(.trailing, 24)
                                }
                        }
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
    var selectedOrder: DbOrderModel? = nil
    
    var orders: [DbOrderModel] = []
    
    func getOrders() async throws {}
    
    
}
