//
//  PortfolioView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/20/23.
//

import SwiftUI

struct PortfolioView: View {
    var body: some View {
        ZStack{
            
            Color.green
                .opacity(0.1)
                .ignoresSafeArea()
            VStack{
                Image(R.image.image_no_portfolio.name)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 36)
                Text("Cooming Soon")
                    .font(.headline)
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
