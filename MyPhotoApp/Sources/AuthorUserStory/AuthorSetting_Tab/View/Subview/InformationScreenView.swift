//
//  InformationScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/19/23.
//

import SwiftUI

struct InformationScreenView: View {
    var height = UIScreen.main.bounds.size.height
    internal var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                   return version
               } else {
                   return R.string.localizable.version_not_available()
               }
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

       var btnBack : some View { Button(action: {
           self.presentationMode.wrappedValue.dismiss()
           }) {
                    Image(systemName: "chevron.left.circle.fill")// set image here
                       .font(.title)
                       .foregroundStyle(.white, Color(R.color.gray1.name).opacity(0.7))
           }
       }
    var body: some View {
        VStack(alignment: .center) {
            Image(R.image.image_logo.name)
                .padding(.top, height / 12)
            Text("\(R.string.localizable.app_version()) \(appVersion)")
                .font(.caption)
                .foregroundColor(Color(R.color.gray3.name))
                .padding(.bottom, 36)
            
            Link(destination: URL(string: "http://takeaphoto.app")!) {
                VStack {
                    Text(R.string.localizable.contact_with_us())
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray1.name))
                        .padding(8)
                }
            }
            
            Text(R.string.localizable.notes())
                .font(.caption)
                .foregroundColor(Color(R.color.gray3.name))
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct InformationScreenView_Previews: PreviewProvider {
    static var previews: some View {
        InformationScreenView()
    }
}
