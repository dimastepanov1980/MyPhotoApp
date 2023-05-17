//
//  LoginView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            MainTextFieldView(nameTextField: R.string.localizable.email(), text: "")
            MainTextFieldView(nameTextField: R.string.localizable.password(), text: "")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
