//
//  AuthorEditScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/24/24.
//

//
//  AuthorMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/21/23.
//

import SwiftUI
import Combine
import MapKit

struct AuthorEditScreenView: View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    @EnvironmentObject var viewModel: AuthorMainScreenViewModel
    
    @State var showActionSheet: Bool = false
    @State var shouldScroll = false
    let currentDate = Date()
    let calendar = Calendar.current
    
    var body: some View {
            VStack {
                if !viewModel.authorOrders.isEmpty{
                                ScrollView(.vertical, showsIndicators: false) {
                                    verticalCards
                                        .padding(.bottom, 42)
                                        .padding(.top, 12)
                                    
                                }
                    } else {
                        ZStack{
                            Color(.systemBackground)
                                .ignoresSafeArea()
                            
                            Text(R.string.localizable.order_not_found_worning())
                                .multilineTextAlignment(.center)
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                                .padding()
                        }
                    }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(R.string.localizable.settings_name_screen())
            .background(Color(.systemBackground))

    }
    var verticalCards: some View {
        VStack(alignment: .center) {
            ForEach(viewModel.authorOrders.indices.sorted(by: { viewModel.authorOrders[$0].orderShootingDate > viewModel.authorOrders[$1].orderShootingDate }), id: \.self) { index in
                if calendar.compare(viewModel.authorOrders[index].orderShootingDate, to: currentDate, toGranularity: .day) == .orderedAscending {
                    AuthorVCellMainScreenView(items: CellOrderModel(order: viewModel.authorOrders[index]),
                                              statusColor: viewModel.orderStausColor(order: viewModel.authorOrders[index].orderStatus),
                                              status: viewModel.orderStausName (status: viewModel.authorOrders[index].orderStatus)) {
                        router.push(.AuthorDetailOrderView(index: index))
                    }
                }
            }
        }  .padding(.horizontal)
    }
}


