//
//  MessageField.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/3/24.
//

import SwiftUI

struct MessageField: View {
    @Binding var message: String
    let action: () async throws -> Void

    var body: some View {
        ZStack(alignment: .top){
            Rectangle()
                .frame(height: 90)
                .foregroundColor(Color(R.color.gray6.name))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .ignoresSafeArea(.all)
            HStack{
                TextField(R.string.localizable.customer_search_bar(), text: $message)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(6)
                    .padding(.leading, 12)
                    .background(
                        Rectangle()
                            .fill(Color(.systemBackground))
                            .cornerRadius(25)
                    )
                Button(action: {
                    Task{
                        try await action()
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundStyle(Color(R.color.gray3.name))
                })
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)


        }
    }
}

#Preview {
    MessageField(message: .constant("Hello"), action: {})
}
