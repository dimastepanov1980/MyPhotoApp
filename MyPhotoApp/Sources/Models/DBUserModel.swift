//
//  DBUserModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

struct DBUserModel: Codable {
    let userId: String
    let description: String?
    let email: String?
    let photoURL: String?
    let dateCreate: Date?
    //add updeting bool property https://youtu.be/elGMTQGRZGo?t=1062
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.description = auth.description
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreate = Date()
    }

    init(userId: String,
         description: String? = nil,
         email: String? = nil,
         photoURL: String? = nil,
         dateCreate: Date? = nil
    ){
        self.userId = userId
        self.description = description
        self.email = email
        self.photoURL = photoURL
        self.dateCreate = dateCreate
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case description = "description"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreate = "date_create"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreate = try container.decodeIfPresent(Date.self, forKey: .dateCreate)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreate, forKey: .dateCreate)
        
    }
}
