//
//  PublicFunction.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/1/23.
//

import Foundation

public func stringToURL(imageString: String) -> URL? {
    guard let imageURL = URL(string: imageString) else { return nil }
    return imageURL
}
