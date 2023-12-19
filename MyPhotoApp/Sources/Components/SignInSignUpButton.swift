//
//  SignInSignUpButton.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 12/19/23.
//

import SwiftUI

struct SignInSignUpButton: View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    var body: some View {
        VStack(alignment: .leading, spacing: 10){
        Text(R.string.localizable.signin_to_continue())
            .font(.subheadline)
            .foregroundColor(Color(R.color.gray3.name))
        
        CustomButtonXl(titleText: R.string.localizable.logIn(), iconName: "lock") {
            Task{
                router.push(.SignInSignUpView(authType: .signIn))
            }
        }
        
        Button {
            router.push(.SignInSignUpView(authType: .signUp))
        } label: {
            HStack{
                Text(R.string.localizable.signup_to_continue())
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
                Text(R.string.localizable.registration())
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(R.color.gray3.name))
            }
        }
    }
        .padding(.bottom, 14)    }
}

#Preview {
    SignInSignUpButton()
}
