//
//  DBUserModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

struct DBUserModel: Codable {
    let userId: String
    let email: String?
    let dateCreate: Date?
    let userType: String?
    
    init(auth: UserDataModel, userType: String) {
        self.userId = auth.uid
        self.email = auth.email
        self.dateCreate = Date()
        self.userType = userType
    }

    init(userId: String,
         email: String? = nil,
         dateCreate: Date? = nil,
         userType: String? = nil
    ){
        self.userId = userId
        self.email = email
        self.dateCreate = dateCreate
        self.userType = userType
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case dateCreate = "date_create"
        case userType = "user_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreate = try container.decodeIfPresent(Date.self, forKey: .dateCreate)
        self.userType = try container.decodeIfPresent(String.self, forKey: .userType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreate, forKey: .dateCreate)
        try container.encodeIfPresent(self.userType, forKey: .userType)
    }
}
