//
//  MessagerModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/2/24.
//

import Foundation

struct MessagerModel: Codable, Identifiable {
    var id: String
    var authorId: String
    var customerId: String
    var messages: [DBMessageModel]
    
    init(item: DBMessagerModel) {
        self.id = item.id
        self.authorId = item.authorId
        self.customerId = item.customerId
        self.messages = item.messages
    }
}


struct MessageModel: Codable, Identifiable, Hashable {
    var id: String
    var message: String
    var timestamp: Date
    var isViewed: Bool
    var received: Bool
    
    init(id: String, message: String, timestamp: Date, isViewed: Bool, recived: Bool) {
        self.id = id
        self.message = message
        self.timestamp = timestamp
        self.isViewed = isViewed
        self.received = recived
    }
    init(message: DBMessageModel) {
        self.id = message.id
        self.message = message.message
        self.timestamp = message.timestamp
        self.isViewed = message.isViewed
        self.received = message.recived
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.id == rhs.id
    }
}
