//
//  LoginView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/17/23.
//

import SwiftUI

struct LoginView: View {
    @State var index : Int = 1
    @State var offsetWidth: CGFloat = UIScreen.main.bounds.width
    var width = UIScreen.main.bounds.size.width
    var height = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack(spacing: 0) {
            
            TabName(index: self.$index, offset: self.$offsetWidth)
                .padding(.top, height / 6)
                
            
            HStack(alignment: .top, spacing: 0) {
                    RegisterTab()
                        .frame(width: width)
                    SignInTab()
                        .frame(width: width)
                
                } .padding(.top, height / 6)
                .offset(x: index == 1 ? width / 2 : -width / 2)
        }
    }
}

struct TabName: View {
    @Binding var index : Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    var body: some View {
        HStack(spacing: 32) {
            VStack(spacing: 7) {
                Button {
                    self.index = 1
                    self.offset = 0
                } label: {
                    Text("Register")
                        .foregroundColor(Color(R.color.gray1.name))
                        .font(.title)
                        .fontWeight(.bold)
                }
                Capsule()
                    .fill(self.index == 1 ? Color(R.color.gray4.name) : Color.clear )
                    .frame(width: 60, height: 2)
            }
            
            VStack(spacing: 7) {
                Button {
                    self.index = 2
                    self.offset = -self.width
                } label: {
                    Text("Sign in")
                        .foregroundColor(Color(R.color.gray1.name))
                        .font(.title)
                        .fontWeight(.bold)
                }
                Capsule()
                    .fill(self.index == 2 ? Color(R.color.gray4.name) : Color.clear )
                    .frame(width: 60, height: 2)
            }
            
        }
        
    }
}


struct RegisterTab: View {
    
    var body: some View {
   
            VStack {
                MainTextField(nameTextField: R.string.localizable.email(), text: "")
                MainTextField(nameTextField: R.string.localizable.password(), text: "")
                Spacer()
                ButtonXl(titleText: R.string.localizable.createAccBtt(), iconName: "camera.aperture") {
                    //
                }

            }
        
        
    }
}

struct SignInTab: View {
    
    var body: some View {
        
            VStack {
                MainTextField(nameTextField: R.string.localizable.email(), text: "")
                MainTextField(nameTextField: R.string.localizable.password(), text: "")
                Button {
                    //
                } label: {
                    Text(R.string.localizable.forgotPss())
                }
                
                Spacer()
                ButtonXl(titleText: R.string.localizable.signIn(), iconName: "camera.aperture") {
                    //
                }
            }
            
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
