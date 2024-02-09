//
//  CustomerPageHubView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/24/23.
//

import SwiftUI

struct CustomerPageHubView: View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    @EnvironmentObject var orders: CustomerOrdersViewModel

    @State var index = 0
    @StateObject private var viewModel = CustomerMainScreenViewModel(userProfileIsSet: .constant(false))

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
                            VStack{
                                ProgressView("Loading...")
                            }.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                        } else {
                            CustomerMainScreenView(with: viewModel, searchPageShow: $searchPageShow, requestLocation: $requestLocation)
                                .toolbar(.hidden, for: .navigationBar)
                                .navigationBarBackButtonHidden(true)
                        }
                    }
                case 1:
                    CustomerOrdersView()
                        .navigationBarBackButtonHidden(true)

                case 2:
                    Color.green
                case 3:
                    SettingScreenView(with: SettingScreenViewModel())
                        .navigationBarBackButtonHidden(true)

                default:
                    EmptyView()
                }
                
                if searchPageShow {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                        CustomerCustomTabs(index: $index, messagesCounter: $orders.newMessagesCount)
                    }
                }
            }

        .sheet(isPresented: $profileIsShown) {
            CustomButtonXl(titleText: R.string.localizable.setup_your_profile(), iconName: "person.crop.circle") {
                self.profileIsShown = true
                self.userProfileIsSet = false
            }
            .padding(.horizontal)
            .presentationDetents([.fraction(0.12)])
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            Task{
                do{
                    if viewModel.portfolio.isEmpty {
                        viewModel.portfolio =  try await viewModel.getPortfolioForLocation(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
                    }
                } catch {
                    print("Error fetching Location: \(error)")
                }
            }
        }
    }
}


struct CustomerPageHubView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerPageHubView()
    }
}
