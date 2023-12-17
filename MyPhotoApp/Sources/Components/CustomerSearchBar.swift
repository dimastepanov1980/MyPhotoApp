//
//  CustomerSearchBar.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/20/23.
//

import SwiftUI

struct CustomerSearchBar: View {
    @Binding var searchText: String
    @Binding var searchPageShow: Bool
    let action: () -> Void
    let onTapAction: () -> Void
    

    var body: some View {

            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(R.color.gray3.name))
                    .font(.footnote)
                    .padding(.leading, 6)

                TextField(R.string.localizable.customer_search_bar(), text: $searchText)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
                    .autocorrectionDisabled()

                if searchText.isEmpty && !searchPageShow {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                        .padding(.horizontal, 4)
                        .foregroundColor(Color(R.color.gray4.name))
                        .onTapGesture {
                        action()
                        }
                }

            }
            .padding(10)
            .background(Color(R.color.gray6.name))
            .cornerRadius(42)
            .onTapGesture {
                withAnimation {
                    onTapAction()
                }
            }
    }
}

struct CustomerSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSearchBar(searchText: .constant(""), searchPageShow: .constant(true)) {
            //
        } onTapAction: {
            
        }
    }
}
