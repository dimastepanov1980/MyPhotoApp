//
//  CustomerMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI

struct CustomerMainScreenView<ViewModel: CustomerMainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    @Binding var portfolio: [AuthorPortfolioModel]

    
    @Namespace var filterspace: Namespace.ID
    @Binding var filterShow: Bool
    @State var onlyFemale: Bool = false
    @State var chooseDate: Date = Date()
    @Binding var requestLocation: Bool
    @State var showDetailView = false
    @State var showAlertRequest = false

    init(with viewModel: ViewModel,
         filterShow: Binding<Bool>,
         requestLocation: Binding<Bool>,
         portfolio: Binding<[AuthorPortfolioModel]>) {
        self.viewModel = viewModel
        self._filterShow = filterShow
        self._requestLocation = requestLocation
        self._portfolio = portfolio
    }
    
    var body: some View {
        NavigationStack {
            if filterShow {
                ZStack {
                    ScrollView{
                        VStack{
                            ForEach(portfolio, id: \.id) { item in
                                CustomerMainCellView(items: item)
                                    .onTapGesture {
                                        viewModel.selectedItem = item
                                        showDetailView.toggle()
                                    }
                                    .fullScreenCover(isPresented: $showDetailView) {
                                        if let selectedItem = viewModel.selectedItem {
                                            CustomerDetailScreenView(with: CustomerDetailScreenViewModel(items: selectedItem), showDetailView: $showDetailView)
                                        }
                                    }
                                    .onAppear{
                                        Task{
                                            do{
                                                try await viewModel.imagePathToURL(imagePath: item.smallImagesPortfolio)
                                            }catch{
                                                throw error
                                            }
                                            
                                        }
                                    }
                                    .padding(.bottom)
                            }
                            
                        }
                        .padding(.vertical, 64)
                        .frame(maxWidth: .infinity)
                    }
                    VStack{
                        HStack {
                        seatchLocation
                            .padding(.leading)
                            .matchedGeometryEffect(id: "search", in: filterspace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                    filterShow.toggle()
                                }
                            }
                            
                        Button {
                            //
                        } label: {
                            Image(R.image.ic_filter.name)
                                .padding(.trailing)
                        }
                        }
                        .background(Color.white)
                        Spacer()
                       Group {
                            CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                    filterShow.toggle()
                                }
                                
                            }
                            .matchedGeometryEffect(id: "CustomButtonXl", in: filterspace)
                            .offset(y: 200)
                        }
                    }
                }
                
            } else {
                ZStack {
//                    ScrollView {
                            VStack(spacing: 20){
                                searchSection
                                    .matchedGeometryEffect(id: "search", in: filterspace)
                                dateSection
                                onlyFemaleSection
                                Spacer()
                            }
                            .padding(.top)
                            .matchedGeometryEffect(id: "overlay", in: filterspace)
                            .padding(.horizontal)
                            .background(Color.white)
//                    }
                    VStack {
                        Spacer()
                        CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                Task {
                                    let dbPortfolio = try await viewModel.getPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude)
                                    if !dbPortfolio.isEmpty{
                                        portfolio = dbPortfolio.map { $0 }
                                        print("chek new location inside Task \(viewModel.longitude); \(viewModel.latitude)")
                                        print("Print portfolio in Task \(viewModel.portfolio)")
                                    } else {
                                        showAlertRequest.toggle()
                                    }
                                }
                                filterShow.toggle()
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
                                            self.viewModel.latitude = result.latitude
                                            self.viewModel.longitude = result.longitude
                                            self.viewModel.regionAuthor = result.regionCode
                                            print("set new location \(viewModel.longitude); \(viewModel.latitude)")

                                        }
                                    }
                                }
                            }
                        }
                        .background(Color.white)
                    }.offset(y: 60)
                }
            }
        }.alert(R.string.localizable.customer_search_no_result(), isPresented: $showAlertRequest) {
        }
    }
    
    private var seatchLocation: some View {
        VStack {
            CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
         }
     }
    private var locationRsult: some View {
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
                                viewModel.locationAuthor = result.location
                                viewModel.latitude = result.latitude
                                viewModel.longitude = result.longitude
                                viewModel.regionAuthor = result.regionCode
                                Task {
                                    do {
                                        let dbPortfolio = try await viewModel.getPortfolio(longitude: result.longitude, latitude: result.latitude)
                                        viewModel.portfolio = dbPortfolio.map { $0 }
                                        print(result.longitude, result.latitude)
                                        print(viewModel.portfolio)
                                    } catch {
                                        print(String(describing: error))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.white)
        }
     }
    private var searchSection: some View {
        VStack {
            CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
        }
        .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)


     }
    private var dateSection: some View {
        VStack {
            DatePicker("Chose Date", selection: $chooseDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
        }
            .background(Color.white)
            .cornerRadius(20, corners: .allCorners)
            .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)

     }
    private var onlyFemaleSection: some View {
            Toggle(isOn: $onlyFemale) {
                HStack {
                    Image(R.image.ic_female.name)
                        .foregroundColor(Color(R.color.gray3.name))

                    Text(R.string.localizable.gender_specify_gender())
                        .font(.callout)
                        .foregroundColor(Color(R.color.gray4.name))
                }.padding(.leading)
            }
            .tint(Color(R.color.gray2.name))
        .padding(8)
        .background(Color.white)
        .cornerRadius(20, corners: .allCorners)
        .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.05), lineWidth: 1)
        )

    }

}
struct CustomerMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        CustomerMainScreenView(with: mockModel, filterShow: .constant(true), requestLocation: .constant(false), portfolio: .constant([]))
    }
}

private class MockViewModel: CustomerMainScreenViewModelType, ObservableObject {
    func getPortfolio(longitude: Double, latitude: Double) async throws -> [AuthorPortfolioModel] {
        []
    }
    func getCurrentLocation() {}
    var locationResult: [DBLocationModel] = []
    var locationAuthor: String = ""
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
                                                          schedule: []))]
    
    func stringToURL(imageString: String) -> URL? {
        URL(string: "")
    }
    
    func currencySymbol(for regionCode: String) -> String {
        ""
    }
    
}

