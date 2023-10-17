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
            HStack {
                if let location = items.authorLocation {
                    Text(location)
                        .lineLimit(1)
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
                if let name = items.authorName, let secondName = items.authorSecondName  {
                    Text("\(name) \(secondName)")
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
                                                                 customerName: nil,
                                                                 customerSecondName: nil,
                                                                 customerDescription: "",
                                                                 customerContactInfo: DbContactInfo(instagramLink: nil, phone: nil, email: nil),
                                                                 instagramLink: ""))
}
