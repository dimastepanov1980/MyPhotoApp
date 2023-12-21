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
    var isDisabled: Bool
    
    var body: some View {
        HStack {
            TextField(nameTextField, text: $text)
                    .frame(height: 42)

//                .padding(10)
                .autocorrectionDisabled()
            Button {
                self.text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(R.color.gray4.name))
            }
        }
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(R.color.gray5.name), lineWidth: 1))
        .padding(.horizontal)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomTextField(nameTextField: "Email", text: .constant(""), isDisabled: true)
    }
}
