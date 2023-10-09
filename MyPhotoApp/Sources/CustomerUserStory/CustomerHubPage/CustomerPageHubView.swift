//
//  CustomerPageHubView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomerPageHubView: View {
    @State var index = 0
    @State var portfolio: [AuthorPortfolioModel] = []
    @StateObject private var viewModel = CustomerMainScreenViewModel()

    @Binding var showAuthenticationView: Bool


    
    @State private var showAddOrderView: Bool = false
    @State private var requestLocation: Bool = false
    @State var serchPageShow: Bool = true

    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                if self.index == 0 {
                    CustomerMainScreenView(with: CustomerMainScreenViewModel(), serchPageShow: $serchPageShow, requestLocation: $requestLocation, portfolio: $portfolio)
                } else if self.index == 1 {
                    Color.red
                } else if self.index == 2 {
                    Color.green
                } else if self.index == 3 {
                    SettingScreenView(with: SettingScreenViewModel(), showAuthenticationView: $showAuthenticationView, isShowActionSheet: .constant(false))
                }
            }
            .padding(.bottom, -40)
            if serchPageShow {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    CustomerCustomTabs(index: $index)
                }
                }
        }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                viewModel.getCurrentLocation()
                Task {
                    do {
                        portfolio = try await viewModel.getPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
                        print("portfolio \(portfolio)")
                        print("viewModel.portfolio \(viewModel.portfolio)")
                    } catch {
                        throw error
                    }
                }
            }
    }
}

struct CustomerPageHubView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageHubView(showAuthenticationView: .constant(false))
    }
}
