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
    @Binding var path: NavigationPath
    
    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    
    @State private var profileIsShow: Bool = false
    @State private var userProfileIsSet: Bool = false
    @State private var showProfileView: Bool = false
    
    @State private var portfolioIsShow: Bool = false
    @State private var userPortfolioIsSet: Bool = false
    @State private var showPortfolioView: Bool = false

    var body: some View {
            VStack{
                ZStack {
                    if self.index == 0 {
                        
                        AuthorMainScreenView(with: AuthorMainScreenViewModel(userProfileIsSet: $userProfileIsSet, userPortfolioIsSet: $userPortfolioIsSet), showSignInView: $showAuthenticationView, showEditOrderView: $showEditOrderView, statusOrder: .Upcoming, path: $path )
                        
                    } else if self.index == 1 {
                        
                        AuthorMainScreenView(with: AuthorMainScreenViewModel(userProfileIsSet: $userProfileIsSet, userPortfolioIsSet: $userPortfolioIsSet), showSignInView: $showAuthenticationView,
                                             showEditOrderView: $showEditOrderView,
                                             statusOrder: .InProgress, path: $path )
                    } else if self.index == 2 {
                        PortfolioView(with: PortfolioViewModel(portfolioIsShow: $portfolioIsShow), path: $path)
                    } else if self.index == 3 {
                        SettingScreenView(with: SettingScreenViewModel(), showAuthenticationView: $showAuthenticationView, path: $path)
                    }
                }
                .padding(.bottom, -40)
                AuthorCustomTabs(showAddOrderView: $showAddOrderView, index: self.$index)
            }
            .sheet(isPresented: !profileIsShow ? $userProfileIsSet : .constant(false) ) {
                CustomButtonXl(titleText: R.string.localizable.setup_your_profile(), iconName: "person.crop.circle") {
                        self.showProfileView = true
                        self.userProfileIsSet = false
                    }
                .presentationDetents([.fraction(0.12)])
            }
            .sheet(isPresented: !portfolioIsShow /*|| profileIsShow && userPortfolioIsSet*/ ? $userPortfolioIsSet : .constant(false) ) {
                CustomButtonXl(titleText: R.string.localizable.setup_your_portfolio(), iconName: "photo.on.rectangle") {
                    self.showPortfolioView = true
                    self.userPortfolioIsSet = false
                    self.portfolioIsShow = true
                }
                .presentationDetents([.fraction(0.12)])
            }
            .navigationDestination(isPresented: $showProfileView) {
                ProfileScreenView(with: ProfileScreenViewModel(profileIsShow: $profileIsShow), path: $path)
            }
            .navigationDestination(isPresented: $showPortfolioView) {
                    PortfolioView(with: PortfolioViewModel(portfolioIsShow: $portfolioIsShow), path: $path)
            }
            .edgesIgnoringSafeArea(.bottom)
            .fullScreenCover(isPresented: $showAddOrderView) {
                NavigationStack {
                    AuthorAddOrderView(with: AuthorAddOrderViewModel(order: DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "", orderStatus: "", orderShootingDate: Date(), orderShootingTime: [], orderShootingDuration: "", orderSamplePhotos: [], orderMessages: nil, authorId: nil, authorName: "", authorSecondName: "", authorLocation: "",   customerId: nil, customerName: nil, customerSecondName: nil, customerDescription: "",   customerContactInfo: DbContactInfo(instagramLink: nil, phone: nil, email: nil)))), showAddOrderView: $showAddOrderView, mode: .new)
                }
                .onAppear { UIDatePicker.appearance().minuteInterval = 15 }

            }
    }
}


struct AuthorHubPageView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorHubPageView(showAuthenticationView: .constant(false), path: .constant(NavigationPath()))
    }
}


