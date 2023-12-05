//
//  CustomerSearchBar.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/20/23.
//

import SwiftUI

struct CustomerSearchBar: View {
    @State var nameTextField: String
    @Binding var text: String
    @State var isTapped = false
    
    var body: some View {

            
        HStack {

            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(R.color.gray3.name))
                TextField(nameTextField, text: $text)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
            }

        }
        .padding(12)
        .background(Color(R.color.gray7.name))
        .cornerRadius(20)
      

    }
}

struct CustomerSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: .constant(""), isTapped: false)
    }
}
