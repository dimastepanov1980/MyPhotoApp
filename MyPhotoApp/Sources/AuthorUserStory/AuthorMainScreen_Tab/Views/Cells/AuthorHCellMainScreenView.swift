//
//  AuthorHCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

import SwiftUI

struct AuthorHCellMainScreenView: View {
    let items: DbOrderModel

    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let customerName = items.customerName, let customerSecondName = items.customerSecondName {
                    Text("\(customerName) \(customerSecondName)")
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
                            
                            Text(items.orderShootingDate.displayHours)
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                                .foregroundColor(Color(R.color.gray2.name))

                            if let duration = items.orderShootingDuration {
                                
                                Text("\(duration)\(R.string.localizable.order_hour())")
                                    .font(.footnote)
                                    .foregroundColor(Color(R.color.gray3.name))
                            }
                        }
                            
                    }
                    Spacer()
                        
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
    let mocData: DbOrderModel = DbOrderModel(order: OrderModel(orderId: UUID().uuidString,
                                                                     orderCreateDate: Date(),
                                                                     orderPrice: "5500",
                                                                     orderStatus: "Upcoming",
                                                                     orderShootingDate: Date(),
                                                                     orderShootingTime: [""],
                                                                     orderShootingDuration: "1",
                                                                     orderSamplePhotos: [],
                                                                     orderMessages: true,
                                                                     authorId: "",
                                                                     authorName: "",
                                                                     authorSecondName: "",
                                                                     authorLocation: "",
                                                                     customerId: nil,
                                                                     customerName: "Dima",
                                                                     customerSecondName: "Stepanov",
                                                                     customerDescription: "",
                                                                     customerContactInfo: ContactInfo(instagramLink: nil, phone: nil, email: nil)))
        
    
}
