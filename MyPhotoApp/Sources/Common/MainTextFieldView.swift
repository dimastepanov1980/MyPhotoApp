//
//  MainTextFieldView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI

struct MainTextFieldView: View {
    
    @State var nameTextField: String
    @State var text: String
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
                        .scaleEffect(isTapped ? 0.8 : 1)
                        .offset(x: isTapped ? -7 : 0, y: isTapped ? -35 : 0 )
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
        .padding()
        
    }
}


struct MainTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MainTextFieldView(nameTextField: "Name of Text field", text: "")
    }
}
