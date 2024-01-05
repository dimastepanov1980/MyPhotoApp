//
//  MessagerViewModelType.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/1/24.
//

import Foundation

@MainActor
protocol MessagerViewModelType: ObservableObject {
    var getMessage: MessagerModel?  { get set }
    
    func subscribe()
    func addNewMessage(message: MessageModel) async throws
}
