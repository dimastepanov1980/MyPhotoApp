//
//  DetailMessageView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/19/24.
//

import SwiftUI
struct DetailMessageModel: Hashable, Equatable{
    var messageCount: String
}

final class DetailMessageViewModel: ObservableObject {
    @Published var message: DetailMessageModel
    
    init(message: DetailMessageModel) {
        self.message = message
    }
}

struct DetailMessageView: View {
    @StateObject private var viewModel: DetailMessageViewModel
    
    init(with viewModel: DetailMessageViewModel) {
           _viewModel = StateObject(wrappedValue: viewModel)
       }

    var body: some View {
        Text(viewModel.message.messageCount)
    }
}

//#Preview {
//    DetailMessageView(viewModel: DetailMessageViewModel())
//}
