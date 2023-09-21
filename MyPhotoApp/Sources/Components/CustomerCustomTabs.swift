//
//  CustomerCustomTabs.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomerCustomTabs: View {
    @Binding var index: Int
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .frame(height: 80)
                    .foregroundColor(Color(R.color.gray7.name))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.15), radius: 10)
                    .ignoresSafeArea(.all)
                
                HStack(alignment: .center, spacing: 45) {
                    tabButton(index: 0, icon: "camera.fill", name: R.string.localizable.customer_tabs_home())
                    tabButton(index: 1, icon: "message.fill", name: R.string.localizable.customer_tabs_message())
                    tabButton(index: 2, icon: "heart.fill", name: R.string.localizable.customer_tabs_liked())
                    tabButton(index: 3, icon: "person.fill", name: R.string.localizable.customer_tabs_profile())
                }.offset(y: -10)
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
            .frame(width: 50, height: 30)
            
        }
    }
}

struct CustomerCustomTabs_Previews: PreviewProvider {
    static var previews: some View {
        CustomerCustomTabs(index: .constant(0))
    }
}

