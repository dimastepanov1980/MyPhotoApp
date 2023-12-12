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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(R.image.image_logo.name)
                .padding(.top, height / 12)
            Text("\(R.string.localizable.app_version()) \(appVersion)")
                .font(.caption)
                .foregroundColor(Color(R.color.gray3.name))
                .padding(.bottom, 36)
            Spacer()
            
                Text(R.string.localizable.contact_with_us())
                .font(.footnote.bold())
                    .foregroundColor(Color(R.color.gray1.name))
                    .multilineTextAlignment(.center)
            HStack(spacing: 20){
                Link(destination: URL(string: "http://takeaphoto.app")!) {
                    Image(systemName: "network")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(Color(R.color.gray3.name))
                }
                
                Link(destination: URL(string: "http://t.me/takeaphotoapp")!) {
                    Image(R.image.image_telegram.name)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(Color(R.color.gray3.name))
                }
            }

            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
    }
    
    private var customBackButton : some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left.circle.fill")// set image here
               .font(.title)
               .foregroundStyle(Color(.systemBackground), Color(R.color.gray1.name).opacity(0.7))
        }
    }

}

struct InformationScreenView_Previews: PreviewProvider {
    static var previews: some View {
        InformationScreenView()
    }
}
