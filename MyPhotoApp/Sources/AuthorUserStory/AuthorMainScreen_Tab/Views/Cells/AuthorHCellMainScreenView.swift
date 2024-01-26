//
//  AuthorHCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

import SwiftUI

struct AuthorHCellMainScreenView: View {
    var items: CellOrderModel
    let action: () -> Void

    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                    Text("\(items.customerName) \(items.customerSecondName)")
                        .lineLimit(1)
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top) {
                            Image(systemName: "clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                                .foregroundColor(Color(R.color.gray2.name))
                            
                            Text(items.orderShootingTime)
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                                .foregroundColor(Color(R.color.gray2.name))
                            
                                Text("\(items.orderShootingDuration)\(R.string.localizable.order_hour())")
                                    .font(.footnote)
                                    .foregroundColor(Color(R.color.gray3.name))
                        }
                    }
                    Spacer()
                        ZStack{
                            Image(systemName: "message")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22)
                                .foregroundColor(Color(R.color.gray2.name))
                            messages(messageCounter: items.newMessagesAuthor)

                        }.padding(.trailing, 8)
                }
            } .padding(.vertical, 12)
            .frame(width: 165)
            .padding(.horizontal, 16)
            .background(Color(R.color.gray5.name))
            .cornerRadius(16)
            .onTapGesture {
                action()
            }
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
        AuthorHCellMainScreenView(items: mockModel.mocData, action: {
            
        })
    }
}


private class MockViewModelHCell: ObservableObject {
    let mocData: CellOrderModel = CellOrderModel(orderPrice: "5500",
                                                 orderStatus: "Upcoming",
                                                 orderShootingDate: Date(),
                                                 orderShootingTime: "",
                                                 orderShootingDuration: "1",
                                                 newMessagesAuthor: 1,
                                                 newMessagesCustomer: 1,
                                                 authorName: "",
                                                 authorSecondName: "",
                                                 authorLocation: "",
                                                 customerName: "Dima",
                                                 customerSecondName: "Stepanov",
                                                 customerDescription: "")
        
    
}
