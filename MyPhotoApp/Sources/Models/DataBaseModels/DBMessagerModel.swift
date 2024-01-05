//
//  DBMessagerModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/3/24.
//

import Foundation

struct DBMessagerModel: Codable, Identifiable {
    let id: String
    let authorId: String
    let customerId: String
    let messages: [DBMessageModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.authorId = try container.decode(String.self, forKey: .authorId)
        self.customerId = try container.decode(String.self, forKey: .customerId)
        self.messages = try container.decode([DBMessageModel].self, forKey: .messages)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "order_id"
        case authorId = "author_id"
        case customerId = "customer_id"
        case messages = "messages"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.authorId, forKey: .authorId)
        try container.encode(self.customerId, forKey: .customerId)
        try container.encode(self.messages, forKey: .messages)
    }
}

struct DBMessageModel: Codable, Equatable, Identifiable, Hashable {
    let id: String
    let message: String
    let timestamp: Date
    let isViewed: Bool
    let recived: Bool
    
    init(message: MessageModel) {
        self.id = message.id
        self.message = message.message
        self.timestamp = message.timestamp
        self.isViewed = message.isViewed
        self.recived = message.received
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.message = try container.decode(String.self, forKey: .message)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.isViewed = try container.decode(Bool.self, forKey: .isViewed)
        self.recived = try container.decode(Bool.self, forKey: .recived)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case message = "message"
        case timestamp = "timestamp"
        case isViewed = "is_viewed"
        case recived = "recived"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.isViewed, forKey: .isViewed)
        try container.encode(self.recived, forKey: .recived)
    }
}
