//
//  CustomerStatusOrderScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/22/23.
//

import SwiftUI

struct CustomerStatusOrderScreenView: View {
    let title: String
    let message: String
    let buttonTitle: String
    @EnvironmentObject var router: Router<Views>
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(R.color.gray1.name))
            
            Text(message)
                .font(.callout)
                .foregroundColor(Color(R.color.gray3.name))
            
            Button {
                router.popToRoot()
            } label: {
                        Text(buttonTitle)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(R.color.gray6.name))
                            .padding(12)
                            .padding(.horizontal, 36)
                            .background(Color(R.color.gray1.name))
                            .cornerRadius(36)
            }
            .padding(.top, 36)

        }
        .multilineTextAlignment(.center)
        .navigationBarBackButtonHidden(true)

    }
}

struct CustomerStatusOrderScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerStatusOrderScreenView(title: "Hello", message: "Welcome", buttonTitle: "Best Idea")
    }
}
