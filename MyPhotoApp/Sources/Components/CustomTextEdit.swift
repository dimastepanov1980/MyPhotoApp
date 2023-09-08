//
//  CustomTextEdit.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/1/23.
//

import SwiftUI
/*
struct CustomTextEdit: View {
    @State var nameTextField: String
    @Binding var text: String
    @State var isTapped = false
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                TextField(<#T##title: StringProtocol##StringProtocol#>, text: <#T##Binding<String>#>, prompt: <#T##Text?#>, axis: <#T##Axis#>)
                TextEditor(text: $text) { (status) in
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
                        .scaleEffect(isTapped || !text.isEmpty ? 0.8 : 1)
                        .offset(x: isTapped || !text.isEmpty ? -7 : 0, y: isTapped || !text.isEmpty ? -35 : 0 )
                        .foregroundColor(Color(R.color.gray4.name)),
                    alignment: .leading
                )
                
            }

            /*
            Button {
                self.text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(R.color.gray4.name))
            }
             */
        }
        .frame(height: 42)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(R.color.gray5.name), lineWidth: 1))
        .padding(.horizontal)
    }
}

struct CustomTextEdit_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEdit(nameTextField: "", text: Binding<String>)
    }
}
*/
