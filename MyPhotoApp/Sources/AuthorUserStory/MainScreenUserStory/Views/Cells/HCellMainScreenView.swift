//
//  AuthorHCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

import SwiftUI

struct AuthorHCellMainScreenView: View {
    let items: UserOrdersModel

    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let location = items.location {
                    Text(location)
                        .lineLimit(1)
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                }

                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top) {
                            Image(systemName: "clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                                .foregroundColor(Color(R.color.gray2.name))
                            
                            Text(items.date.displayHours)
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                                .foregroundColor(Color(R.color.gray2.name))

                            if let duration = items.duration {
                                
                                Text("\(duration)\(R.string.localizable.order_hour())")
                                    .font(.footnote)
                                    .foregroundColor(Color(R.color.gray3.name))
                            }
                        }
                            
                    }
                    Spacer()
                    /*
                    Image(R.image.image0.name)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36)
                        .overlay(Circle().stroke(Color(R.color.gray6.name), lineWidth: 1).shadow(radius: 10))
                       */
                        
                }
            } .padding(.vertical, 12)
            .frame(width: 165)
            .padding(.horizontal, 16)
            .background(Color(R.color.gray5.name))
            .cornerRadius(16)

    }
}

extension Date {
    var displayHours: String {
        self.formatted(
            .dateTime
                .hour(.conversationalDefaultDigits(amPM: .omitted))
                .minute()
        )
    }
}

struct AuthorHCellMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModelHCell()
    
    static var previews: some View {
        AuthorHCellMainScreenView(items: mockModel.mocData)
    }
}


private class MockViewModelHCell: ObservableObject {
    let mocData: UserOrdersModel = UserOrdersModel(order: OrderModel(orderId: UUID().uuidString,
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
