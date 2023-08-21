//
//  CustomTabBar.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/10/23.
//

import SwiftUI

struct CustomTabBar: View {
    @State var index = 0
    @Binding var showSignInView: Bool
    @State private var showAddOrderView: Bool = false
    @State private var showEditOrderView: Bool = false
    @State private var isShowActionSheet: Bool = false

    var body: some View {
        VStack{
            ZStack {
                if self.index == 0 {
                    MainScreenView(with: MainScreenViewModel(), showSignInView: $showSignInView, showEditOrderView: $showEditOrderView, showAddOrderView: $showAddOrderView, statusOrder: .Upcoming )
                } else if self.index == 1 {
                    
                    MainScreenView(with: MainScreenViewModel(), showSignInView: $showSignInView,
                                   showEditOrderView: $showEditOrderView,
                                   showAddOrderView: $showAddOrderView,
                                   statusOrder: .InProgress )
                    } else if self.index == 2 {
                    PortfolioView()
                } else if self.index == 3 {
                    SettingScreenView(with: SettingScreenViewModel(), showSignInView: $showSignInView, isShowActionSheet: $isShowActionSheet)
                }
            }
            .padding(.bottom, -40)
            .ignoresSafeArea()
                
            CustomTabs(showAddOrderView: $showAddOrderView, index: self.$index)

        }
        .background(Color(R.color.gray6.name))
        .fullScreenCover(isPresented: $showAddOrderView) {
            NavigationStack {
                AddOrderView(with: AddOrderViewModel(order: UserOrdersModel(order: OrderModel(orderId: "", name: "", instagramLink: "", price: "", location: "", description: "", date: Date(), duration: "", imageUrl: [], status: ""))), showAddOrderView: $showAddOrderView, mode: .new)
            }
        }

    }
}

struct CustomTabs: View {
    @Binding var showAddOrderView: Bool
    @Binding var index: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Circle()
                .foregroundColor(Color(R.color.gray6.name))
                .frame(height: 80)
            
            Button {
                showAddOrderView.toggle()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color(R.color.gray1.name))
                        .frame(height: 80)
                    
                    Image(systemName: "camera.aperture")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color(R.color.gray6.name))
                    
                }
            }
            
       HStack(alignment: .bottom, spacing: 20) {
                Button {
                    self.index = 0
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(self.index == 0 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        Text(R.string.localizable.tabs_feature())
                            .font(.caption2)
                            .foregroundColor(self.index == 0 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
                .padding(.trailing, 20)
                Button {
                    self.index = 1
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "paintbrush.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(self.index == 1 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        Text(R.string.localizable.tabs_edit())
                            .font(.caption2)
                            .foregroundColor(self.index == 1 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
                
          Spacer()
           
                Button {
                    self.index = 2
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(self.index == 2 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        
                        Text(R.string.localizable.tabs_portfolio())
                            .font(.caption2)
                            .foregroundColor(self.index == 2 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
                Button {
                    self.index = 3
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(self.index == 3 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        Text(R.string.localizable.tabs_profile())
                            .font(.caption2)
                            .foregroundColor(self.index == 3 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
            }
      }.padding(.horizontal, 36)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(showSignInView: .constant(false))
    }
}


