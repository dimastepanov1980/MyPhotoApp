//
//  CustomerConfirmOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/28/23.
//

import SwiftUI

struct CustomerConfirmOrderView<ViewModel: CustomerConfirmOrderViewModelType>: View {
    @ObservedObject var viewModel: ViewModel

    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustomerConfirmOrderView_Previews: PreviewProvider {
    private static let mocItems = MockViewModel()

    static var previews: some View {
        CustomerConfirmOrderView(with: mocItems)
    }
}

private class MockViewModel: CustomerConfirmOrderViewModelType, ObservableObject {
    
}
