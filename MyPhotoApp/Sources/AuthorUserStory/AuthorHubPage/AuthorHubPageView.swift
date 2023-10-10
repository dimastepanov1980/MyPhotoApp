//
//  AuthorHubPageView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/10/23.
//

import SwiftUI

struct AuthorHubPageView: View {
    @State var index = 0
    @Binding var showAuthenticationView: Bool
    
    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    @State private var isShowActionSheet: Bool = false

    var body: some View {
        VStack{
            ZStack {
                if self.index == 0 {
                    AuthorMainScreenView(with: AuthorMainScreenViewModel(), showSignInView: $showAuthenticationView, showEditOrderView: $showEditOrderView, statusOrder: .Upcoming )
                } else if self.index == 1 {
                    
                    AuthorMainScreenView(with: AuthorMainScreenViewModel(), showSignInView: $showAuthenticationView,
                                   showEditOrderView: $showEditOrderView,
                                   statusOrder: .InProgress )
                    } else if self.index == 2 {
                        PortfolioView(with: PortfolioViewModel())
                } else if self.index == 3 {
                    SettingScreenView(with: SettingScreenViewModel(), showAuthenticationView: $showAuthenticationView, isShowActionSheet: $isShowActionSheet)
                }
            }
            .padding(.bottom, -40)
            AuthorCustomTabs(showAddOrderView: $showAddOrderView, index: self.$index)
        }
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $showAddOrderView) {
            NavigationStack {
                AuthorAddOrderView(with: AuthorAddOrderViewModel(order: DbOrderModel(order: AuthorOrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "", orderStatus: "", orderShootingDate: Date(), orderShootingTime: [], orderShootingDuration: "", orderSamplePhotos: [], orderMessages: nil, authorId: nil, authorName: "", authorSecondName: "", authorLocation: "",   customerId: nil, customerName: nil, customerSecondName: nil, customerDescription: "",   customerContactInfo: DbContactInfo(instagramLink: nil, phone: nil, email: nil), instagramLink: nil))), showAddOrderView: $showAddOrderView, mode: .new)
            }
        }

    }
}


struct AuthorHubPageView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorHubPageView(showAuthenticationView: .constant(false))
    }
}


