//
//  CustomerSearchBar.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/20/23.
//

import SwiftUI

struct CustomerSearchBar: View {
    @State var nameTextField: String
    @Binding var text: String
    @State var isTapped = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(R.color.gray3.name))
                VStack(alignment: .leading, spacing: 4) {
                    TextField("", text: $text) { (status) in
                        if status {
                            withAnimation(.easeIn) {
                                isTapped = true
                            }
                        } else {
                            if text == "" {
                                withAnimation(.easeOut) {
                                    isTapped = false
                                }
                            }
                        }
                    }
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
                    .background (
                        Text(nameTextField)
                            .font(.callout)
                            .scaleEffect(isTapped || !text.isEmpty ? 0.7 : 0.9)
                            .offset(x: isTapped || !text.isEmpty ? -55 : 0, y: isTapped || !text.isEmpty ? -30 : 0 )
                            .foregroundColor(Color(R.color.gray4.name)),
                        alignment: .leading
                    )
                    
                    
                }
                
            }
            .padding(.horizontal)
            
            
        }
        .background (
            Color.white
                .cornerRadius(20),
            alignment: .leading
        )
        .frame(height: 42)
    }
}

struct CustomerSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: .constant(""), isTapped: false)
    }
}
