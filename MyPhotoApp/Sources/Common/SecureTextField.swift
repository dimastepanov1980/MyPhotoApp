//
//  SecureTextField.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/18/23.
//

import SwiftUI

struct SecureTextField: View {
    @State var nameSecureTextField: String
    @State var text: String
    @State var isTapped = false
    
    var body: some View {
        HStack {
            SecureField("", text: $text, prompt: Text(nameSecureTextField))
                .padding(10)
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
        .padding()
        
    }
}

struct SecureTextField_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextField(nameSecureTextField: R.string.localizable.password(), text: "")
    }
}
