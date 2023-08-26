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
        ZStack(alignment: .bottom) {
            CustomerMainScreenView(with: CustomerMainScreenViewModel())
            CustomerCustomTabs(showAddOrderView: $showAddOrderView, index: $index)
        }.ignoresSafeArea()
    }
}

struct CustomerPageHubView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageHubView()
    }
}
