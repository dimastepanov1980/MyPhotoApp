//
//  CustomerMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI

struct CustomerMainScreenView<ViewModel: CustomerMainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    
    @Namespace var filterspace: Namespace.ID
    @Binding var searchPageShow: Bool
    @Binding var requestLocation: Bool
    @Binding var path: NavigationPath
    
    @State var selectDate: Date = Date()
    @State var selectLocation: String = ""
    
    
    init(with viewModel: ViewModel,
         searchPageShow: Binding<Bool>,
         requestLocation: Binding<Bool>,
         path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._searchPageShow = searchPageShow
        self._requestLocation = requestLocation
        self._path = path
    }
    
    var body: some View {
        VStack {
            if searchPageShow {
                ZStack {
                    ScrollView{
                        VStack{
                            ForEach(viewModel.portfolio, id: \.id) { portfolio in
                                NavigationLink(value: portfolio) {
                                    CustomerMainCellView(items: portfolio)
                                }
                            }
                        }
                        .padding(.vertical, 64)
                        .frame(maxWidth: .infinity)
                        .navigationDestination(for: AuthorPortfolioModel.self) { portfolio in
                            CustomerDetailScreenView(with: CustomerDetailScreenViewModel(portfolio: portfolio), startMyTripDate: selectDate, path: $path)
                        }
                    }
                    .scrollIndicators(.hidden)
                    VStack{
                        HStack {
                            searchLocationButton
                                .matchedGeometryEffect(id: "search", in: filterspace)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                        searchPageShow.toggle()
                                    }
                                }
                        }
                        .background(Color.white)
                        Spacer()
                        Group {
                            CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                    searchPageShow.toggle()
                                }
                                
                            }
                            .matchedGeometryEffect(id: "CustomButtonXl", in: filterspace)
                            .offset(y: 200)
                        }
                    }
                }
            } else {
                ZStack {
                    VStack(spacing: 20){
                        searchSection
                            .matchedGeometryEffect(id: "search", in: filterspace)
                        dateSection
                        Spacer()
                    }
                    .padding(.top)
                    .matchedGeometryEffect(id: "overlay", in: filterspace)
                    .padding(.horizontal)
                    .background(Color.white)
                    VStack {
                        Spacer()
                        CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
//                                Task {
//                                    let dbPortfolio = try await viewModel.getPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude, date: selectDate)
//                                    print("dbPortfolio new location \(dbPortfolio) Coordinate: \(viewModel.longitude); \(viewModel.latitude)")
//
//                                    if !dbPortfolio.isEmpty{
//                                        //                                        portfolio = dbPortfolio.map { $0 }
//                                        //                                        print("chek new location inside Task \(viewModel.longitude); \(viewModel.latitude)")
//                                        //                                        print("Print portfolio in Task \(viewModel.portfolio)")
//                                    } else {
//                                        showAlertRequest.toggle()
//                                    }
//                                }
                                searchPageShow.toggle()
                                print("chek new location \(viewModel.longitude); \(viewModel.latitude)")
                                
                            }
                            
                        }.matchedGeometryEffect(id: "CustomButtonXl", in: filterspace)
                            .offset(y: -80)
                    }
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
                        .background(Color.white)
                    }.offset(y: 60)
                }
            }
        }
        .onAppear{
            print("CustomerMainScreenView Path Count: \(path.count)")
        }
    }
    private var searchLocationButton: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(R.color.gray3.name))
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectLocation.isEmpty ? R.string.localizable.customer_search_bar() : selectLocation)
                        .font(.callout)
                        .foregroundColor(selectLocation.isEmpty ? Color(R.color.gray4.name) : Color(R.color.gray2.name))
                }
                
            }.padding(.horizontal)
            
        }.frame(height: 40)
            .padding(.horizontal)

     }
    private var searchSection: some View {
        VStack {
            CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
        }
        .shadow(color: Color(.sRGBLinear, white: 0.2, opacity: 0.05),radius: 5)


     }
    private var dateSection: some View {
        VStack {
            DatePicker("Chose Date", selection: $selectDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .onChange(of: selectDate) { newDate in
                self.viewModel.selectedDate = newDate
                print("Selected date changed to: \( self.viewModel.selectedDate)")
                 }
        }
            .background(Color.white)
            .cornerRadius(20, corners: .allCorners)
            .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)

     }
}
struct CustomerMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        CustomerMainScreenView(with: mockModel, searchPageShow: .constant(true), requestLocation: .constant(false), path: .constant(NavigationPath()))
    }
}

private class MockViewModel: CustomerMainScreenViewModelType, ObservableObject {
    var userProfileIsSet: Bool = true
    func getPortfolio(longitude: Double, latitude: Double, date: Date) async throws -> [AuthorPortfolioModel] {
        []
    }
    func fetchLocation() async throws {}
    func getCurrentLocation() {}
    var locationResult: [DBLocationModel] = []
    var locationAuthor: String = ""
    var selectedDate: Date = Date()
    var regionAuthor: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var imagesURLs: [URL]? = []
    func imagePathToURL(imagePath: [String]) async throws {}
    
    var selectedItem: AuthorPortfolioModel?
    
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

