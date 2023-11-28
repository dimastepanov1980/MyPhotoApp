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
        HStack{
            ZStack {
                RoundedRectangle(cornerRadius: 21)
                    .fill(isDisabled ? Color(R.color.gray6.name) : .white)
                    .frame(height: 40)
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
                            .offset(x: isTapped || !text.isEmpty ? -10 : 0, y: isTapped || !text.isEmpty ? -30 : 0 )
                            .foregroundColor(Color(R.color.gray4.name)),
                        alignment: .leading
                    )
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    
                }
                .frame(height: 42)
                .padding(.horizontal)
                .overlay{
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1)
                }
                
            }.padding(.horizontal)
        }
    }
}

