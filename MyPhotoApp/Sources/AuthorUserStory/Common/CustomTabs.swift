//
//  CustomTabs.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomTabs: View {
    @Binding var showAddOrderView: Bool
    @Binding var index: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack{
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


struct CustomTabs_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabs(showAddOrderView: .constant(true), index: .constant(0))
    }
}
