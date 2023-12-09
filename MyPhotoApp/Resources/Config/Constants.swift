//
//  Constants.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 6/27/23.
//

import Foundation

enum Constants {
    
    enum CustomError: Error {
        case invalidURL
        case invalidResponse
    }
    
    enum UserTypeDependencies {
        case author
        case customer
    }
    
    enum OrderMode {
        case new
        case edit
    }
    
}

