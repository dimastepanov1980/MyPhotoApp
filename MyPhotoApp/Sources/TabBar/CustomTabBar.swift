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
    @State private var selectedSection = "In Progres"
    var section = ["In Progres", "Complited"]

    
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
                    SettingScreenView(with: SettingScreenViewModel(), showSignInView: $showSignInView)
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
        ZStack {
            HStack(alignment: .bottom) {
                Button {
                    self.index = 0
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "camera.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(self.index == 0 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        Text("Feature")
                            .font(.caption2)
                            .foregroundColor(self.index == 0 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
                
                Spacer(minLength: 0)
                Button {
                    self.index = 1
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "paintbrush.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(self.index == 1 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        Text("Edit")
                            .font(.caption2)
                            .foregroundColor(self.index == 1 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
                
                Spacer(minLength: 0)
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
                
                
                Spacer(minLength: 0)
                Button {
                    self.index = 2
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(self.index == 2 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        
                        Text("Portfolio")
                            .font(.caption2)
                            .foregroundColor(self.index == 2 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
                
                Spacer(minLength: 0)
                Button {
                    self.index = 3
                } label: {
                    VStack(spacing: 4){
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(self.index == 3 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                        Text("Profil")
                            .font(.caption2)
                            .foregroundColor(self.index == 3 ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                    }
                }
            }

            .ignoresSafeArea()
            .padding(.horizontal, 36)
            .background(Color(R.color.gray6.name))
            .clipShape(CShape())
        }
        
    }
}
struct CShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: 0, y: 32))
            path.addLine(to: CGPoint(x: 0, y: (rect.height) + 40))
            path.addLine(to: CGPoint(x: rect.width, y: (rect.height) + 40))
            path.addLine(to: CGPoint(x: rect.width, y: 32))
            
            path.addArc(center: CGPoint(x: (rect.width / 2) - 6, y: 40),
                         radius: 40,
                        startAngle: .zero,
                         endAngle: .init (degrees: 180),
                         clockwise: true)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(showSignInView: .constant(false))
    }
}


