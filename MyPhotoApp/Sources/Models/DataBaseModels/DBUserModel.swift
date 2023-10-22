//
//  DBUserModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/8/23.
//

import Foundation

struct DBUserModel: Codable {
    let userId: String
    let firstName: String?
    let secondName: String?
    let instagramLink: String?
    let phone: String?
    let email: String?
    let dateCreate: Date?
    let userType: String?
    
    init(auth: UserDataModel, userType: String, firstName: String, secondName: String, instagramLink: String, phone: String) {
        self.userId = auth.uid
        self.firstName = firstName
        self.secondName = secondName
        self.instagramLink = instagramLink
        self.phone = phone
        self.email = auth.email
        self.dateCreate = Date()
        self.userType = userType
    }

    init(userId: String,
         firstName: String? = nil,
         secondName: String? = nil,
         instagramLink: String? = nil,
         phone: String? = nil,
         email: String? = nil,
         dateCreate: Date? = nil,
         userType: String? = nil
    ){
        self.userId = userId
        self.firstName = firstName
        self.secondName = secondName
        self.instagramLink = instagramLink
        self.phone = phone
        self.email = email
        self.dateCreate = dateCreate
        self.userType = userType
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case secondName = "second_name"
        case instagramLink = "instagram_link"
        case phone = "phone"
        case email = "email"
        case dateCreate = "date_create"
        case userType = "user_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.secondName = try container.decodeIfPresent(String.self, forKey: .secondName)
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreate = try container.decodeIfPresent(Date.self, forKey: .dateCreate)
        self.userType = try container.decodeIfPresent(String.self, forKey: .userType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.secondName, forKey: .secondName)
        try container.encodeIfPresent(self.instagramLink, forKey: .instagramLink)
        try container.encodeIfPresent(self.phone, forKey: .phone)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreate, forKey: .dateCreate)
        try container.encodeIfPresent(self.userType, forKey: .userType)
    }
}
