//
//  MessagerBubbleCell.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/2/24.
//

import SwiftUI

struct MessagerBubbleCell: View {
    var item: MessageModel
    @EnvironmentObject var user: UserTypeService

    var width = UIScreen.main.bounds.size.width
    var vAlignment: HorizontalAlignment {
        switch user.userType {
        case .author:
            return item.received ? .leading : .trailing
        case .customer:
            return !item.received ? .leading : .trailing
        case .unspecified:
            return .leading
        }
    }
    
    var alignment: Alignment {
        switch user.userType {
        case .author:
            return item.received ? .leading : .trailing
        case .customer:
            return !item.received ? .leading : .trailing
        case .unspecified:
            return .leading
        }
    }
    
    var body: some View {
        VStack(alignment: vAlignment){
            HStack {
                Text("\(item.message)")
                    .font(.callout)
                    .foregroundColor(item.received ? Color(R.color.gray1.name) : Color(R.color.gray1.name))
                    .frame(alignment: user.userType == .customer && item.received ? .leading : .trailing)
                
                    .padding(.horizontal, 18)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    .background(
                        ZStack{
                            Rectangle()
                                .fill(item.received ? Color(R.color.gray6.name) : Color(R.color.gray4.name))
                                .cornerRadius(20, corners: item.received ? [.topRight, .bottomRight, .bottomLeft] : [.topLeft, .topRight, .bottomLeft] )
                            Text(formattedDate(date: item.timestamp, format: "hh:mm"))
                                .frame(minWidth: 0, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottomTrailing)
                                .font(.system(size: 9).italic())
                                .foregroundColor(Color(R.color.gray2.name))
                                .padding(3)
                                .padding(.trailing, 8)
                            
                        }
                    )
            }
            .frame(maxWidth: width * 0.85, alignment: alignment)
        }
        .frame(maxWidth: .infinity, alignment: alignment)

    }

    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

#Preview {
    MessagerBubbleCell(item: messageMoc)
}

var messageMoc: MessageModel = MessageModel(id: UUID().uuidString,
                                              message: "Secure your Firebase database with custom security rules by following this comprehensive tutorial. Learn how to restrict access, prevent unauthorized modifications, and protect sensitive data in your app. Watch now to get started!",
                                              timestamp: Date(),
                                              isViewed: false,
                                              recived: false)
