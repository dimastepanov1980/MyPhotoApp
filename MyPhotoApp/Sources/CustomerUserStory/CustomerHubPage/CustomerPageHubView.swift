//
//  CustomerPageHubView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomerPageHubView: View {
    @State var index = 0
    @State private var portfolio: [AuthorPortfolioModel] = []
    @StateObject private var viewModel = CustomerMainScreenViewModel(userProfileIsSet: .constant(false))

    @Binding var showAuthenticationView: Bool
    @Binding var path: NavigationPath

    @State private var userProfileIsSet: Bool = false
    @State private var profileIsShown: Bool = false
    @State private var showAddOrderView: Bool = false
    @State private var requestLocation: Bool = false
    @State var searchPageShow: Bool = true

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                switch self.index {
                case 0:
                    ZStack{
                        if portfolio.isEmpty {
                            Color(R.color.gray7.name)
                                .ignoresSafeArea(.all)
                            ProgressView("Loading...")
                        } else {
                            CustomerMainScreenView(with: viewModel, searchPageShow: $searchPageShow, requestLocation: $requestLocation, path: $path, portfolio: portfolio)
                        }
                    }
                case 1:
                    CustomerOrdersView(with: CustomerOrdersViewModel())
                case 2:
                    Color.green
                case 3:
                    SettingScreenView(with: SettingScreenViewModel(), showAuthenticationView: $showAuthenticationView)
                default:
                    EmptyView()
                }
            }
            .padding(.bottom, -40)

            if searchPageShow {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    CustomerCustomTabs(index: $index)
                }
            }
        }
        .sheet(isPresented: $profileIsShown) {
            CustomButtonXl(titleText: R.string.localizable.setup_your_profile(), iconName: "person.crop.circle") {
                self.profileIsShown = true
                self.userProfileIsSet = false
            }
            .presentationDetents([.fraction(0.12)])
        }
        .navigationDestination(isPresented: $profileIsShown) {
            ProfileScreenView(with: ProfileScreenViewModel(profileIsShow: $profileIsShown))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            Task{
                do{
                    try await viewModel.fetchLocation()
                    if portfolio.isEmpty {
                        viewModel.getCurrentLocation()
                        portfolio = try await viewModel.getPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
                        
                        print("portfolio \(portfolio)")
                        print("viewModel.portfolio \(viewModel.portfolio)")
                    }
                } catch {
                    print("Error fetching portfolio: \(error)")
                }
            }
        }
        .onAppear{
            print("myPathCount\(path.count)")
        }
        .onChange(of: viewModel.latitude) { _ in
            Task {
                do {
                    portfolio = try await viewModel.getPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
                    print("portfolio \(portfolio)")
                    print("viewModel portfolio NEW Coordinate \(viewModel.portfolio)")
                } catch {
                    print("Error fetching portfolio for  NEW Coordinate : \(error)")
                }
            }
        }
    }
}


struct CustomerPageHubView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageHubView(showAuthenticationView: .constant(false), path: .constant(NavigationPath()))
    }
}
