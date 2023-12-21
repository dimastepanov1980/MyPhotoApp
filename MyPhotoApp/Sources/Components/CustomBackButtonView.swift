//
//  CustomBackButtonView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/21/23.
//

import SwiftUI

struct CustomBackButtonView: View {
    @EnvironmentObject var router: Router<Views>


    var body: some View {
        Button {
            router.pop()
        } label: {
            Image(systemName: "chevron.left.circle.fill")// set image here
               .font(.title)
               .foregroundStyle(Color(.systemBackground), Color(R.color.gray1.name).opacity(0.5))
        }
    }
}

#Preview {
    CustomBackButtonView()
}
