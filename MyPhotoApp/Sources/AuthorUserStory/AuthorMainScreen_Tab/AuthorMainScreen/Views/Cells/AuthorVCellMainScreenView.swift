//
//  AuthorVCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

struct AuthorVCellMainScreenView: View {
    let items: DbOrderModel
    let statusColor: Color
    var status: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                if let customerName = items.customerName, let customerSecondName = items.customerSecondName {
                    Text("\(customerName) \(customerSecondName)")
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                }
                Spacer()
                if let status = status, !status.isEmpty {
                        Text(status)
                            .font(.caption2)
                            .foregroundColor(Color.white)
                            .padding(.horizontal,10)
                            .padding(.vertical, 5)
                            .background(statusColor)
                            .cornerRadius(15)
                    
                }
            }
            HStack(alignment: .top, spacing: 4) {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                
                Text(items.orderShootingDate.formatted(Date.FormatStyle().day().month()))
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding(.trailing)
                
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                
                Text(items.orderShootingDate.formatted(Date.FormatStyle().hour().minute()))
                    .font(.footnote)
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding(.trailing)
                
                Image(systemName: "timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                if let duration = items.orderShootingDuration {
                    Text("\(duration)\(R.string.localizable.order_hour())")
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray2.name))
                }

            }
            HStack(alignment: .bottom) {
                Spacer()
                if let location = items.authorLocation  {
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(Color(R.color.gray5.name))
        .cornerRadius(16)
    }
}

struct AuthorVCellMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModelVCell()
    static var previews: some View {
        AuthorVCellMainScreenView(items: mockModel.mocData, statusColor: Color(R.color.upcoming.name))
    }
}
private class MockViewModelVCell: ObservableObject {
    let mocData: DbOrderModel = DbOrderModel(order:
                                                OrderModel(orderId: UUID().uuidString,
                                                            orderCreateDate: Date(),
                                                                 orderPrice: "5500",
                                                                 orderStatus: "Upcoming",
                                                                 orderShootingDate: Date(),
                                                                 orderShootingTime: ["11:30"],
                                                                 orderShootingDuration: "2",
                                                                 orderSamplePhotos: [],
                                                                 orderMessages: [],
                                                                 authorId: "",
                                                                 authorName: "Author",
                                                                 authorSecondName: "SecondName",
                                                                 authorLocation: "Author Location",
                                                                 customerId: nil,
                                                                 customerName: "customerName",
                                                                 customerSecondName: "customerSecondName",
                                                                 customerDescription: "customerDescription",
                                                                 customerContactInfo: DbContactInfo(instagramLink: "instagramLink", phone: "555-55-55", email: "email@test.com")))
}
