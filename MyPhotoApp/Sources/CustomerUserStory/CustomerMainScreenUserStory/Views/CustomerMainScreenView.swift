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
            ScrollView{
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
                }
                
            }
        }
        
        
    }
}
/*
struct CustomerMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
            CustomerMainScreenView(with: mockModel)
    }
}

private class MockViewModel: CustomerMainScreenViewModelType, ObservableObject {
    var selectedItem: AuthorPortfolioModel?
    
    var showDetailScreen: Bool = false
    
    var portfolio: [AuthorPortfolioModel] = [
        AuthorPortfolioModel(portfolio:
                                DBPortfolioModel(id: UUID().uuidString,
                                                 author:  DBAuthor(id: UUID().uuidString,
                                                                   rateAuthor: 4.32,
                                                                   likedAuthor: true,
                                                                   nameAuthor: "Iryna",
                                                                   familynameAuthor: "Test",
                                                                   sexAuthor: "Female",
                                                                   ageAuthor: "27",
                                                                   location: "th",
                                                                   styleAuthor: ["Test", "Test", "Test", "Test"],
                                                                   imagesCover: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                                                   priceAuthor: "1234"),
                                                 
                                                 avatarAuthor: "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
                                                 
                                                 smallImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1544717304-14d94551b7dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjF8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1608048944439-505d956e1429?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                                 
                                                 largeImagesPortfolio: ["https://images.unsplash.com/photo-1550005809-91ad75fb315f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1738&q=80", "https://images.unsplash.com/photo-1544717304-14d94551b7dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjF8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1546032996-6dfacbacbf3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdlZGRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60","https://images.unsplash.com/photo-1692265963326-1a9a7eafec5d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0M3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://plus.unsplash.com/premium_photo-1692392181683-77be581a5aaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60", "https://images.unsplash.com/photo-1608048944439-505d956e1429?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGxvdmUlMjBzdG9yeXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"],
                                                 
                                                 descriptionAuthor: "As one of the most important parts of your portfolio, it is imperative that your photographer 'About Me' page appears on your website menu. This practice is a must regardless of whether your bio has a dedicated page or appears as a strip on your one-page website. In any case, your visitors shouldn’t have to click more than once before finding it.",

                                                 reviews: [DBReviews(reviewerAuthor: "Safron Sandeev",
                                                                                          reviewDescription: "Best photographer on the world",
                                                                                          reviewRate: 5.0)],
                                                 appointmen: [
                                                    DBAppointmen(data: Date(), timeSlot: [
                                                        DBTimeSlot(time: "09:00", available: true),
                                                        DBTimeSlot(time: "10:00", available: false),
                                                        DBTimeSlot(time: "11:00", available: true),
                                                        DBTimeSlot(time: "12:00", available: true),
                                                        DBTimeSlot(time: "13:00", available: true),
                                                        DBTimeSlot(time: "14:00", available: false),
                                                        DBTimeSlot(time: "15:00", available: false),
                                                        DBTimeSlot(time: "16:00", available: true),
                                                        DBTimeSlot(time: "17:00", available: false),
                                                        DBTimeSlot(time: "18:00", available: true),
                                                        DBTimeSlot(time: "19:00", available: false),
                                                        DBTimeSlot(time: "20:00", available: true) ]),
                                                    
                                                    DBAppointmen(data: Date(), timeSlot: [
                                                        DBTimeSlot(time: "09:30", available: true),
                                                        DBTimeSlot(time: "10:30", available: false),
                                                        DBTimeSlot(time: "11:30", available: true),
                                                        DBTimeSlot(time: "12:30", available: true),
                                                        DBTimeSlot(time: "13:30", available: true),
                                                        DBTimeSlot(time: "14:30", available: false),
                                                        DBTimeSlot(time: "15:30", available: false),
                                                        DBTimeSlot(time: "16:30", available: true),
                                                        DBTimeSlot(time: "17:30", available: false),
                                                        DBTimeSlot(time: "18:30", available: true),
                                                        DBTimeSlot(time: "19:30", available: false),
                                                        DBTimeSlot(time: "20:30", available: true) ])
                                                                                            ]))
    ]
    
    func stringToURL(imageString: String) -> URL? {
        URL(string: "")
    }
    
    func currencySymbol(for regionCode: String) -> String {
        ""
    }
    
}
*/
