//
//  AuthorHubPageView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/10/23.
//

import SwiftUI

struct AuthorHubPageView: View {
    @State var index = 0
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    
    @State private var portfolioIsShow: Bool = false
    @State private var userPortfolioIsSet: Bool = false

    var body: some View {
            VStack{
                ZStack {
                    if self.index == 0 {
                        AuthorMainScreenView()
                            .toolbar(.hidden, for: .navigationBar)
                    } else if self.index == 1 {
                        AuthorEditScreenView()
                        .toolbar(.hidden, for: .navigationBar)
                    } else if self.index == 2 {
                        PortfolioView(with: PortfolioViewModel())
                    } else if self.index == 3 {
                        SettingScreenView(with: SettingScreenViewModel())
                    }
                }
                .padding(.bottom, -40)
                AuthorCustomTabs(index: self.$index)
            }
            .edgesIgnoringSafeArea(.bottom)
    }
}


struct AuthorHubPageView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorHubPageView()
    }
}


