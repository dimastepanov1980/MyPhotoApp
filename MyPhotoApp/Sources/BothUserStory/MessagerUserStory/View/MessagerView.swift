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
            if let message = viewModel.getMessage {
                VStack{
                    ForEach(message.messages, id: \.id) { message in
                        MessagerBubbleCell(item: MessageModel(message: message))
                    }
                }
                .padding(.top)
                .padding(.horizontal, 8)
                Text(String(messageCount ?? 0))
                    .onAppear(perform: {
                        switch user.userType {
                        case .author:
                            let authorRecived = message.messages.filter { $0.recived == false}
                            self.messageCount = authorRecived.count
                            print("authorRecived: \(authorRecived)")
                        case .customer:
                            let customerRecived = message.messages.filter { $0.recived == true}
                            self.messageCount = customerRecived.count
                            print("customerRecived: \(customerRecived)")

                        case .unspecified:
                            break
                        }
                    })

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
                                                             recived: user.userType == .customer)
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
    func addNewMessage(message: MessageModel) async throws {}
    func subscribe() {}
    var orderId: String = ""
    var getMessage: MessagerModel?
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
