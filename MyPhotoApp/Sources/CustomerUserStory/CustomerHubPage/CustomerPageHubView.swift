//
//  CustomerPageHubView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomerPageHubView: View {
    @State var index = 0
    @StateObject private var viewModel = CustomerMainScreenViewModel(userProfileIsSet: .constant(false))

    @Binding var showAuthenticationView: Bool
    @Binding var path: NavigationPath

    @State private var userProfileIsSet: Bool = false
    @State private var profileIsShown: Bool = false
    @State private var showAddOrderView: Bool = false
    @State private var requestLocation: Bool = false
    @State private var searchPageShow: Bool = true

    var body: some View {
            ZStack(alignment: .bottom) {
                switch self.index {
                case 0:
                    ZStack{
                        if viewModel.portfolio.isEmpty {
                            Color(R.color.gray7.name)
                                .ignoresSafeArea(.all)
                            ProgressView("Loading...")
                        } else {
                            CustomerMainScreenView(with: viewModel, searchPageShow: $searchPageShow, requestLocation: $requestLocation, path: $path)
                        }
                    }
                case 1:
                    CustomerOrdersView(with: CustomerOrdersViewModel(), path: $path)
                case 2:
                    Color.green
                case 3:
                    SettingScreenView(with: SettingScreenViewModel(), showAuthenticationView: $showAuthenticationView, path: $path)
                default:
                    EmptyView()
                }
                
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
            ProfileScreenView(with: ProfileScreenViewModel(profileIsShow: $profileIsShown), path: $path)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            Task{
                do{
                    viewModel.portfolio =  try await viewModel.fetchPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)

                } catch {
                    print("Error fetching Location: \(error)")
                }
            }
        }
        .onChange(of: viewModel.latitude) { _ in
            Task {
                do {
                    viewModel.portfolio = try await viewModel.getPortfolioForLocation(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
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
