//
//  CustomerMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI


struct CustomerMainScreenView<ViewModel: CustomerMainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    @State var showDetailView = false
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
            ScrollView{
                    VStack{
                        ForEach(viewModel.portfolio, id: \.id) { item in
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
                                        viewModel.locationAuthor = result.location
                                        viewModel.latitude = result.latitude
                                        viewModel.longitude = result.longitude
                                        viewModel.regionAuthor = result.regionCode
                                        Task {
                                            do {
                                                let dbPortfolio = try await viewModel.getPortfolio(longitude: result.longitude, latitude:  result.latitude)
                                                viewModel.portfolio = dbPortfolio.map { AuthorPortfolioModel(portfolio: $0) }
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
            .safeAreaInset(edge: .top, content: {
                VStack{
                    seatchLocation
                } .background(Color.white)
            })
        }

    }
    
    private var seatchLocation: some View {
        VStack(alignment: .leading) {
            CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
         }
     }

}
struct CustomerMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
            CustomerMainScreenView(with: mockModel)
    }
}

private class MockViewModel: CustomerMainScreenViewModelType, ObservableObject {
    func getPortfolio(longitude: Double, latitude: Double) async throws -> [DBPortfolioModel] {
        []
    }
    
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

