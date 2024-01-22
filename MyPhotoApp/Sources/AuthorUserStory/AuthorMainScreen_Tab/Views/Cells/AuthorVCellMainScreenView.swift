//
//  AuthorVCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

struct AuthorVCellMainScreenView: View {
    var items: CellOrderModel
    var statusColor: Color
    var status: String?
    var newMessagesAuthor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                    Text("\(items.customerName) \(items.customerSecondName)")
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                Spacer()
                if let status = status, !status.isEmpty {
                        Text(status)
                            .font(.caption2)
                            .foregroundColor(Color(.systemBackground))
                            .padding(.horizontal,10)
                            .padding(.vertical, 5)
                            .background(statusColor)
                            .cornerRadius(15)
                }
            }
             HStack(alignment: .top, spacing: 16) {
                 HStack(spacing: 4){
                     Image(systemName: "calendar")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 16)
                         .foregroundColor(Color(R.color.gray2.name))
                     
                     Text(items.orderShootingDate.formatted(Date.FormatStyle().month().day()))
                         .font(.footnote)
                         .foregroundColor(Color(R.color.gray2.name))
                 }
                 HStack(spacing: 4){
                     Image(systemName: "clock")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 16)
                         .foregroundColor(Color(R.color.gray2.name))
                         Text("\(items.orderShootingTime) \(R.string.localizable.order_hour())")
                             .font(.footnote)
                             .foregroundColor(Color(R.color.gray2.name))
                 }
                 HStack(spacing: 4){
                     Image(systemName: "timer")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 16)
                         .foregroundColor(Color(R.color.gray2.name))
                     
                         Text("\(items.orderShootingDuration)\(R.string.localizable.order_hour())")
                             .font(.footnote)
                             .foregroundColor(Color(R.color.gray2.name))
                 }
             }
             HStack(alignment: .center) {
                Spacer()
                    Text(items.authorLocation)
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                 messages(messageCounter: items.newMessagesAuthor)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(Color(R.color.gray5.name))
        .cornerRadius(16)
        
    }
    
    @ViewBuilder
    func messages(messageCounter: Int) -> some View {
        if messageCounter > 0 {
                ZStack{
                    Image(systemName: "message")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(Color(R.color.gray2.name))
                    
                    Text(String(messageCounter))
                        .font(.caption2)
                        .foregroundColor(Color(.systemBackground))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((Color(R.color.red.name)))
                        .cornerRadius(15)
                        .offset(x: 15, y: 5)
                }
        }
    }
}

struct AuthorVCellMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModelVCell()
    static var previews: some View {
        AuthorVCellMainScreenView(items: mockModel.mocData, statusColor: Color(R.color.upcoming.name), newMessagesAuthor: "0")
    }
}
private class MockViewModelVCell: ObservableObject {
    let mocData: CellOrderModel = CellOrderModel (orderPrice: "5500",
                                                  orderStatus: "Upcoming",
                                                  orderShootingDate: Date(),
                                                  orderShootingTime: "11:30",
                                                  orderShootingDuration: "2",
                                                  newMessagesAuthor: 2,
                                                  newMessagesCustomer: 1,
                                                  authorName: "Author",
                                                  authorSecondName: "SecondName",
                                                  authorLocation: "Author Location",
                                                  customerName: "customerName",
                                                  customerSecondName: "customerSecondName",
                                                  customerDescription: "customerDescription")
}
