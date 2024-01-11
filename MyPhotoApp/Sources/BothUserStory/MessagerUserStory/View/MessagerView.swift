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
        ScrollView(showsIndicators: false) {
            if let messages = viewModel.getMessage {
                VStack{
                    ForEach(messages, id: \.id) { orderId in
                            MessagerBubbleCell(item: orderId)
                    }
                }
                .padding(.top)
                .padding(.horizontal, 8)
                /*
                Text(String(messageCount ?? 0))
                    .onAppear(perform: {
                        switch user.userType {
                        case .author:
                            let authorSender = messages.filter { $0.senderIsAuthor == false}
                            let isViewed = authorSender.filter { $0.isViewed }
                            self.messageCount = isViewed.count
                                Task{
                                    try await viewModel.messageViewed(messages: authorSender)
                                }
                            self.messageCount = authorSender.count
                            print("authorRecived: \(authorSender)")
                        case .customer:
                            let customerSender = messages.filter { $0.senderIsAuthor == true}
                            self.messageCount = customerSender.count
                            print("customerRecived: \(customerSender)")

                        case .unspecified:
                            break
                        }
                    })
                 */
            }
        }
        .toolbarBackground(Color(R.color.gray6.name), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .safeAreaInset(edge: .bottom, content: {
            MessageField(message: $message) {
                Task{
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
        .ignoresSafeArea(.container, edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
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
    var getMessage: [MessageModel]?
    var getMessages: [String : [MessageModel]]?

    func messageViewed(messages: [MessageModel]) async throws {}
    func addNewMessage(message: MessageModel) async throws {}
    func subscribe() {}
    var orderId: String = ""
//    = [
//        MessageModel(id: UUID().uuidString, message: "Hello", timestamp: Date(), isViewed: true, recived: true),
//        MessageModel(id: UUID().uuidString, message: "Hello, how are you", timestamp: Date(), isViewed: true, recived: false),
//        MessageModel(id: UUID().uuidString, message: "My Name is Dima", timestamp: Date(), isViewed: true, recived: true),
//        MessageModel(id: UUID().uuidString, message: "Иногда правила безопасности Cloud Firestore проверяют, вошел ли пользователь в систему, но не ограничивают доступ на основе этой аутентификации. Если одно из ваших правил включает auth != null , подтвердите, что вы хотите, чтобы любой вошедший в систему пользователь имел доступ к данным.", timestamp: Date(), isViewed: true, recived: true),
//        MessageModel(id: UUID().uuidString, message: "Иногда правила безопасности Cloud Firestore проверяют, вошел ли пользователь в систему, но не ограничивают доступ на основе этой аутентификации. Если одно из ваших правил включает auth != null , подтвердите, что вы хотите, чтобы любой вошедший в систему пользователь имел доступ к данным.", timestamp: Date(), isViewed: true, recived: true),
//        MessageModel(id: UUID().uuidString, message: "Иногда правила безопасности Cloud Firestore проверяют, вошел ли пользователь в систему, но не ограничивают доступ на основе этой аутентификации. Если одно из ваших правил включает auth != null , подтвердите, что вы хотите, чтобы любой вошедший в систему пользователь имел доступ к данным.", timestamp: Date(), isViewed: true, recived: true),
//        MessageModel(id: UUID().uuidString, message: "Иногда правила безопасности Cloud Firestore проверяют, вошел ли пользователь в систему, но не ограничивают доступ на основе этой аутентификации. Если одно из ваших правил включает auth != null , подтвердите, что вы хотите, чтобы любой вошедший в систему пользователь имел доступ к данным.", timestamp: Date(), isViewed: true, recived: true),
//        MessageModel(id: UUID().uuidString, message: "Иногда правила безопасности Cloud Firestore проверяют, вошел ли пользователь в систему, но не ограничивают доступ на основе этой аутентификации. Если одно из ваших правил включает auth != null , подтвердите, что вы хотите, чтобы любой вошедший в систему пользователь имел доступ к данным.", timestamp: Date(), isViewed: true, recived: true)
//    ]
}
