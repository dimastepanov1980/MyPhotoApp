//
//  MainButtonView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/18/23.
//

import SwiftUI

struct ButtonXl: View {
    private let titleText: String
    private let iconName: String
    private let isActive = false
    private let action: () -> Void
    
    init(titleText: String, iconName: String, action: @escaping () -> Void) {
        self.titleText = titleText
        self.iconName = iconName
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Capsule()
                    .foregroundColor(Color(R.color.gray1.name))
                    .frame(height: 50)
                HStack{
                    Image(systemName: iconName)
                        .foregroundColor(Color(R.color.gray6.name))
                    Text(titleText)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color(R.color.gray6.name))
                }
            }
            .padding(16)
        }
    }
}

struct ButtonXlView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonXl(titleText: R.string.localizable.createAccBtt(),
                     iconName: "camera.aperture") {
            //
        }
    }
}
