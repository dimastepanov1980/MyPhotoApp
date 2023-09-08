//
//  SearchLocationView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/30/23.
/*

import SwiftUI
import Foundation


struct SearchLocationView: View {
    
    @StateObject private var viewModel = SearchLocationViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            CustomTextField(nameTextField: R.string.localizable.portfolio_location(), text: $viewModel.locationAuthor)
            ForEach(viewModel.locationResult) { result in
                if viewModel.locationAuthor != result.city {
                    
                    VStack(alignment: .leading) {
                        Text(result.city)
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray4.name))
                            .padding(.leading, 36)
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.locationAuthor = result.city
                        }
                    }
                }
            }
        }
    }
}

struct SerchLocation_Previews: PreviewProvider {
    static var previews: some View {
        SearchLocationView()
    }
}

*/
