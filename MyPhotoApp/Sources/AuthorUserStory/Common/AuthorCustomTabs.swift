//
//  AuthorCustomTabs.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct AuthorCustomTabs: View {
    @Binding var showAddOrderView: Bool
    @Binding var index: Int
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(Color(R.color.gray7.name))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(radius: 5)
                    .ignoresSafeArea(.all)
                
                HStack(alignment: .center, spacing: 10) {
                    tabButton(index: 0, icon: "camera.fill", name: R.string.localizable.tabs_feature())
                    tabButton(index: 1, icon: "paintbrush.fill", name: R.string.localizable.tabs_edit())
                    apertureButton
                        .offset(y: -25)
                    tabButton(index: 2, icon: "photo.on.rectangle.angled", name: R.string.localizable.tabs_portfolio())
                    tabButton(index: 3, icon: "person.fill", name: R.string.localizable.tabs_profile())
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    private func tabButton(index: Int, icon: String, name: String ) -> some View {
        Button {
            self.index = index
        } label: {
            VStack(spacing: 5){
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .foregroundColor(self.index == index ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
                
                Text(name)
                    .font(.caption2)
                    .foregroundColor(self.index == index ? Color(R.color.gray2.name) : Color(R.color.gray4.name))
            }
            .frame(width: 50, height: 50)
            
        }
    }
    private var apertureButton: some View {
        ZStack{
            Circle()
                .foregroundColor(Color(R.color.gray6.name))
                .frame(width: 80, height: 80)
                .padding(10)
            
            Button {
                showAddOrderView.toggle()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color(R.color.gray1.name))
                        .frame(width: 80, height: 80)
                        .padding(10)
                    
                    Image(systemName: "camera.aperture")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color(R.color.gray6.name))
                    
                }
            }
        }
    }
}

struct AuthorCustomTabs_Previews: PreviewProvider {
    static var previews: some View {
        AuthorCustomTabs(showAddOrderView: .constant(true), index: .constant(0))
    }
}
