//
//  MainTextFieldView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI

struct CustomTextField: View {
    @State var nameTextField: String
    @Binding var text: String
    @State var isTapped = false
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4, content: {
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
                .background (
                    Text(nameTextField)
                        .scaleEffect(isTapped || !text.isEmpty ? 0.8 : 1)
                        .offset(x: isTapped || !text.isEmpty ? -7 : 0, y: isTapped || !text.isEmpty ? -35 : 0 )
                        .foregroundColor(Color(R.color.gray4.name)),
                    alignment: .leading
                )
            })
            
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(R.color.gray4.name))
            }
        }
        .frame(height: 42)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(R.color.gray3.name), lineWidth: 1))
//        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}
