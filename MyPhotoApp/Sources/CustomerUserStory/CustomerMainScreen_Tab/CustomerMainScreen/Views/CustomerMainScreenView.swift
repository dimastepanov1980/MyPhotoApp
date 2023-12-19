//
//  CustomerMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI

struct CustomerMainScreenView<ViewModel: CustomerMainScreenViewModelType> : View {
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService

    @ObservedObject var viewModel: ViewModel
    @Binding var searchPageShow: Bool
    @Binding var requestLocation: Bool
    @FocusState var onFocus: Bool

    @State var selectDate: Date = Date()
    @State var selectLocation: String = ""
    
    
    init(with viewModel: ViewModel,
         searchPageShow: Binding<Bool>,
         requestLocation: Binding<Bool>) {
        self.viewModel = viewModel
        self._searchPageShow = searchPageShow
        self._requestLocation = requestLocation
    }
    
    var body: some View {
        VStack{
            mainPageView(showPageSearch: searchPageShow)
        }
            .navigationBarBackButtonHidden(true)
           /* .toolbar{
                ToolbarItem(placement: .principal) {
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(R.color.gray3.name))
                            .font(.footnote)
                            .padding(.leading, 6)
                        
                        TextField(R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
                            .font(.callout)
                            .foregroundColor(Color(R.color.gray2.name))
                            .autocorrectionDisabled()
                            .focused($onFocus)
                        
                        if !viewModel.locationAuthor.isEmpty && !searchPageShow {
                            Image(systemName: "xmark.circle.fill")
                                .font(.subheadline)
                                .padding(.horizontal, 4)
                                .foregroundColor(Color(R.color.gray4.name))
                                .onTapGesture {
                                    viewModel.locationResult = []
                                    viewModel.locationAuthor = ""
                                    
                                }
                        }
                        
                    }
                    .padding(10)
                    .background(Color(R.color.gray6.name))
                    .cornerRadius(42)
                    .onTapGesture {
                        withAnimation {
                            onFocus = true
                            print("onFocus \(onFocus)")
                            
                            self.searchPageShow = false
                        }
                    }
                }
            } */
            .safeAreaInset(edge: .top, content: {
                ZStack(alignment: .top) {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .frame(height: 20)
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(R.color.gray3.name))
                            .font(.footnote)
                            .padding(.leading, 6)
                        
                        TextField(R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
                            .font(.callout)
                            .foregroundColor(Color(R.color.gray2.name))
                            .autocorrectionDisabled()
                            .focused($onFocus)
                        
                        if !viewModel.locationAuthor.isEmpty && !searchPageShow {
                            Image(systemName: "xmark.circle.fill")
                                .font(.subheadline)
                                .padding(.horizontal, 4)
                                .foregroundColor(Color(R.color.gray4.name))
                                .onTapGesture {
                                    viewModel.locationResult = []
                                    viewModel.locationAuthor = ""
                                    
                                }
                        }
                        
                    }
                    .padding(10)
                    .background(Color(R.color.gray6.name))
                    .cornerRadius(42)
                    .padding(.horizontal, 12)
                    .onTapGesture {
                        withAnimation {
                            onFocus = true
                            print("onFocus \(onFocus)")
                            
                            self.searchPageShow = false
                        }
                    }
                }
            })
            .overlay{
                ScrollView{
                    VStack{
                        ForEach(viewModel.locationResult) { result in
                            if viewModel.locationAuthor != result.location {
                                VStack(alignment: .leading){
                                    Text(result.city)
                                        .font(.subheadline)
                                        .foregroundColor(Color(R.color.gray2.name))
                                        .padding(.leading, 32)
                                    Text(result.location)
                                        .font(.footnote)
                                        .foregroundColor(Color(R.color.gray4.name))
                                        .padding(.leading, 32)
                                    Divider()
                                        .padding(.horizontal, 32)

                                }

                                .onTapGesture {
                                    withAnimation {
                                        self.viewModel.locationAuthor = result.location
                                        selectLocation = result.location
                                        self.viewModel.latitude = result.latitude
                                        self.viewModel.longitude = result.longitude
                                        self.viewModel.regionAuthor = result.regionCode
                                    }
                                }
                            }
                        }
                    }
                }
                .background(Color(.systemBackground))
            }
    }
    
    @ViewBuilder
    func mainPageView(showPageSearch: Bool) -> some View {
        if showPageSearch {
                ScrollView{
                    VStack{
                        ForEach(viewModel.portfolio, id: \.id) { portfolio in
                                CustomerMainCellView(items: portfolio)
                                .onTapGesture {
                                    router.push(.CustomerDetailScreenView(viewModel: portfolio))
                                }
                        }
                    }
                    .padding(.bottom, 110)
                    .padding(.top, 110)
                }
                .ignoresSafeArea()
                .refreshable {
                    Task{
                        do{
                            print("longitude: \(viewModel.longitude), latitude: \(viewModel.latitude)")
                            viewModel.portfolio = try await viewModel.getPortfolioForLocation(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
                        } catch {
                            print("Error refreshable fetching portfolio: \(error)")
                            
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .alert(isPresented: $viewModel.showAlertPortfolio) {
                       Alert(
                        title: Text(viewModel.alertTitle),
                        message: Text(viewModel.alertMessage)
                       )
                   }
        } else {
            ScrollView{
                Text( R.string.localizable.customer_search_select_date())
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
                
                DatePicker("Chose Date", selection: $selectDate, displayedComponents: [.date])
                    .background(Color(R.color.gray6.name).opacity(0.7))
                    .cornerRadius(36)
                .datePickerStyle(.graphical)
                
                .onChange(of: selectDate) { newDate in
                    self.viewModel.selectedDate = newDate
                    print("Selected date changed to: \( self.viewModel.selectedDate)")
                    print("Selected date changed to: \( selectDate)")
                     }
//                .onTapGesture {
//                    self.onFocus.toggle()
//                    print("onFocus \(onFocus)")
//                }
            }
            .padding(.top, 120)
            .padding(.horizontal)
            .safeAreaInset(edge: .bottom) {
                CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                    Task {
                        do {
                            viewModel.portfolio = try await viewModel.getPortfolioForLocation(longitude: viewModel.longitude, latitude: viewModel.latitude, date: viewModel.selectedDate)
                            print("viewModel portfolio NEW Coordinate \(viewModel.portfolio)")
                        } catch {
                            print("Error fetching portfolio for  NEW Coordinate : \(error)")
                        }
                    }
                    
                    withAnimation {
                        self.searchPageShow = true
                    }
                        print("chek new location \(viewModel.longitude); \(viewModel.latitude)")
                    }
                .padding()
                .offset(y: -36)
            }
            .ignoresSafeArea()
        }
    }

}
struct CustomerMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        NavigationStack{
            CustomerMainScreenView(with: mockModel, searchPageShow: .constant(true), requestLocation: .constant(false))
        }
    }
}

private class MockViewModel: CustomerMainScreenViewModelType, ObservableObject {
    func fetchPortfolio(longitude: Double, latitude: Double, date: Date) async throws -> [AuthorPortfolioModel] {
        []
    }
    func getPortfolioForDate(date: Date) async throws -> [AuthorPortfolioModel] {
        []
    }
    func getPortfolioForLocation(longitude: Double, latitude: Double, date: Date) async throws -> [AuthorPortfolioModel] {
        []
    }
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlertPortfolio: Bool  = false
    
    var userProfileIsSet: Bool = true
    func getCurrentLocation() {}
    var locationResult: [DBLocationModel] = []
    var locationAuthor: String = ""
    var selectedDate: Date = Date()
    var regionAuthor: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var imagesURLs: [URL]? = []
    func imagePathToURL(imagePath: [String]) async throws {}
    var showDetailScreen: Bool = false
    var portfolio: [AuthorPortfolioModel] = [AuthorPortfolioModel(portfolio:
                                    DBPortfolioModel(id: UUID().uuidString,
                                                  author:
                                       DBAuthor(rateAuthor: 0.0,
                                                  likedAuthor: true,
                                                  typeAuthor: "photo",
                                                  nameAuthor: "Test",
                                                  familynameAuthor: "Author",
                                                  sexAuthor: "Male",
                                                  ageAuthor: "25",
                                                  location: "Maoi",
                                                  latitude: 0.0,
                                                  longitude: 0.0,
                                                  regionAuthor: "UA",
                                                  styleAuthor: ["Fashion", "Love Story"],
                                                  imagesCover: ["", ""]),
                                                  avatarAuthor: "",
                                                  smallImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                                  largeImagesPortfolio: ["String"],
                                                  descriptionAuthor: "",
                                                     schedule: [],
                                                     bookingDays: [:]))]

    func stringToURL(imageString: String) -> URL? {
        URL(string: "")
    }

    func currencySymbol(for regionCode: String) -> String {
        ""
    }
    
}

