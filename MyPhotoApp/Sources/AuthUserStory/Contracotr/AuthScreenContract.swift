//
//  Contract.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/19/23.
//

import Foundation
import SwiftUI

protocol AuthScreenViewModelType: ObservableObject {
//    var userID: UUID { get }
    var email: String { get set }
    var password: String { get set }
    
    func signIn()
}
