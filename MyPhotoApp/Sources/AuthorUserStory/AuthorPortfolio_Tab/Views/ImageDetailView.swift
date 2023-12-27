//
//  ImageDetailView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/27/23.
//

import SwiftUI

struct ImageDetailView: View {
    var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            } else {
                ZStack{
                    ProgressView()
                        .tint(Color.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView())
    }

}

#Preview {
    ImageDetailView()
}
