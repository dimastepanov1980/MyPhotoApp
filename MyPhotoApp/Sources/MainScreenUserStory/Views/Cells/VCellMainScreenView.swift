//
//  VCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

struct VCellMainScreenView: View {
    let items: UserOrdersModel
    
    var body: some View {
        HStack(alignment: .bottom){
            VStack(alignment: .leading, spacing: 8) {
              
                if let location = items.location {
                    Text(location)
                        .lineLimit(1)
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                }
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                        .foregroundColor(Color(R.color.gray2.name))
                    
                    Text(items.date.formatted(Date.FormatStyle().hour().minute()))
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray2.name))
                        .padding(.trailing)
                    
                    Image(systemName: "timer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                        .foregroundColor(Color(R.color.gray2.name))
                    if let duration = items.duration {
                        Text("\(duration)\(R.string.localizable.order_hour())")
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray2.name))
                    }
                    
                }
                
                Image(R.image.image0.name)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                    .overlay(Circle().stroke(Color(R.color.gray6.name), lineWidth: 1).shadow(radius: 10))
                
            }
            Spacer()
            if let name = items.name {
                Text(name)
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
            }
        }.padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(Color(R.color.gray5.name))
        .cornerRadius(16)
    }
}

struct VCellMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModelVCell()

    static var previews: some View {
        VCellMainScreenView(items: mockModel.mocData)
    }
}

private class MockViewModelVCell: ObservableObject {
    let mocData: UserOrdersModel = UserOrdersModel(order:
                                                    OrderModel(orderId: UUID().uuidString,
                                                               name: "Katy Igor",
                                                               instagramLink: nil,
                                                               price: "5500",
                                                               location: "Kata",
                                                               description: "Some Text",
                                                               date: Date(),
                                                               duration: "2",
                                                               imageUrl: [],
                                                               status: "Upcoming"))
}
