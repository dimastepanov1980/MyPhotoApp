//
//  SecureTextField.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/18/23.
//

import SwiftUI

struct CustomSecureTextField: View {
    @State var nameSecureTextField: String
    @Binding var text: String
    @State var isTapped = false
    
    var body: some View {
        HStack {
            SecureField("", text: $text, prompt: Text(nameSecureTextField))
                .padding(10)
            Button {
                self.text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(R.color.gray4.name))
            }
        }
        .frame(height: 42)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(R.color.gray5.name), lineWidth: 1))
        .padding(.horizontal)
    }
}

