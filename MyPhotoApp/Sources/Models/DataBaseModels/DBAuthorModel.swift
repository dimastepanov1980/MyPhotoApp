//
//  DBAuthorModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/20/23.
//

import Foundation

struct DBAuthor: Codable {
    let rateAuthor: Double
    let likedAuthor: Bool
    let typeAuthor: String
    let nameAuthor: String
    let familynameAuthor: String
    let sexAuthor: String
    let ageAuthor: String
    let location: String
    let regionAuthor: String
    var latitude: Double
    var longitude: Double
    let styleAuthor: [String]
    let imagesCover: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rateAuthor = try container.decode(Double.self, forKey: .rateAuthor)
        self.typeAuthor = try container.decode(String.self, forKey: .typeAuthor)
        self.likedAuthor = try container.decode(Bool.self, forKey: .likedAuthor)
        self.nameAuthor = try container.decode(String.self, forKey: .nameAuthor)
        self.familynameAuthor = try container.decode(String.self, forKey: .familynameAuthor)
        self.sexAuthor = try container.decode(String.self, forKey: .sexAuthor)
        self.ageAuthor = try container.decode(String.self, forKey: .ageAuthor)
        self.location = try container.decode(String.self, forKey: .location)
        self.regionAuthor = try container.decode(String.self, forKey: .regionAuthor)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.styleAuthor = try container.decode([String].self, forKey: .styleAuthor)
        self.imagesCover = try container.decode([String].self, forKey: .imagesCover)
    }

    init(rateAuthor: Double, likedAuthor: Bool, typeAuthor: String, nameAuthor: String, familynameAuthor: String, sexAuthor: String, ageAuthor: String, location: String, latitude: Double, longitude: Double, regionAuthor: String, styleAuthor: [String], imagesCover: [String]) {
        self.rateAuthor = rateAuthor
        self.likedAuthor = likedAuthor
        self.typeAuthor = typeAuthor
        self.nameAuthor = nameAuthor
        self.familynameAuthor = familynameAuthor
        self.sexAuthor = sexAuthor
        self.ageAuthor = ageAuthor
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.regionAuthor = regionAuthor
        self.styleAuthor = styleAuthor
        self.imagesCover = imagesCover
    }
    
    enum CodingKeys: String, CodingKey {
        case rateAuthor = "rate_author"
        case likedAuthor = "liked_author"
        case typeAuthor = "type_author"
        case nameAuthor = "name_author"
        case familynameAuthor = "familyname_author"
        case sexAuthor = "sex_author"
        case ageAuthor = "age_author"
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
        case regionAuthor = "region_author"
        case styleAuthor = "style_author"
        case imagesCover = "images_cover"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rateAuthor, forKey: .rateAuthor)
        try container.encode(self.typeAuthor, forKey: .typeAuthor)
        try container.encode(self.likedAuthor, forKey: .likedAuthor)
        try container.encode(self.nameAuthor, forKey: .nameAuthor)
        try container.encode(self.familynameAuthor, forKey: .familynameAuthor)
        try container.encode(self.sexAuthor, forKey: .sexAuthor)
        try container.encode(self.ageAuthor, forKey: .ageAuthor)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.regionAuthor, forKey: .regionAuthor)
        try container.encode(self.styleAuthor, forKey: .styleAuthor)
        try container.encode(self.imagesCover, forKey: .imagesCover)
    }
}
