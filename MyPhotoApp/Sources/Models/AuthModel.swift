//
//  AuthDataResultModel.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
