//
//  MessagerView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/1/24.
//

import SwiftUI

struct MessagerView<ViewModel: MessagerViewModelType>: View {
    @EnvironmentObject var user: UserTypeService
    @ObservedObject private var viewModel: ViewModel
    var navigationTitle: String
    @State private var message = ""
    @State private var messageCount: Int?
    
    init(with viewModel: ViewModel,
         navigationTitle: String) {
        self.viewModel = viewModel
        self.navigationTitle = navigationTitle
    }
    
    var body: some View {
        VStack{
            if let messages = viewModel.getMessage {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(messages, id: \.id) { message in
                                
                                MessagerBubbleCell(item: message)
                                    .id(message.id)
                                    .onAppear {
                                        if user.userType == .author && (viewModel.getMessage?.last?.senderIsAuthor) == false {
                                            if !message.isViewed {
                                                Task{
                                                    try await viewModel.messageViewed(message: message, user: .author)
                                                    print("author is view messages")
                                                }
                                            }
                                        } else if user.userType == .customer && (viewModel.getMessage?.last?.senderIsAuthor) == true {
                                            print("customer recive messages")
                                            if !message.isViewed {
                                                Task{
                                                    try await viewModel.messageViewed(message: message, user: .customer)
                                                    print("customer is view messages")
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal, 8)
                        .onReceive(viewModel.objectWillChange) { _ in
                            if let lastMessageID = viewModel.getMessage?.last?.id {
                                withAnimation {
                                    proxy.scrollTo(lastMessageID, anchor: .bottom)
                                }
                            }
                        }
                        .onAppear {
                                if let lastMessageID = messages.last?.id {
                                    proxy.scrollTo(lastMessageID, anchor: .bottom)
                                }
                        }
                    }
                    .toolbarBackground(Color(R.color.gray6.name), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .safeAreaInset(edge: .bottom, content: {
                        MessageField(message: $message) {
                            Task {
                                let sendMessage: MessageModel = MessageModel(id: UUID().uuidString,
                                                                             message: message,
                                                                             timestamp: Date(),
                                                                             isViewed: false,
                                                                             senderIsAuthor: user.userType == .author)
                                self.message = ""
                                try await viewModel.addNewMessage(message: sendMessage)
                            }
                        }
                    })
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationTitle(navigationTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    
                    
                }
            }
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButtonView())
    }

}


struct MessagerView_Previews: PreviewProvider {
    private static let mocItems = MockViewModel()
    static var previews: some View {
        NavigationStack{
            MessagerView(with: mocItems, navigationTitle: "Iryna Tndaeva")
        }
    }
}


private class MockViewModel: MessagerViewModelType, ObservableObject {
    func messageViewed(message: MessageModel, user: Constants.UserType) async throws {}
    
    var getMessage: [MessageModel]?
    var orderId: String = ""
    func addNewMessage(message: MessageModel) async throws {}
    func subscribe() {}
}
