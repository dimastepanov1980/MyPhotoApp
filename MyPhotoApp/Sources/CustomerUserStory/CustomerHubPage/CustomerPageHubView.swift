//
//  CustomerPageHubView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomerPageHubView: View {
    @State var index = 0
    @State private var showAddOrderView: Bool = false
    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                if self.index == 0 {
                    CustomerMainScreenView(with: CustomerMainScreenViewModel())
                } else if self.index == 1 {
                    Color.red
                } else if self.index == 2 {
                    Color.green
                } else if self.index == 3 {
                    Color.blue
                }
            }
            .padding(.bottom, -40)
            
            CustomerCustomTabs(index: $index)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomerPageHubView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageHubView()
    }
}
