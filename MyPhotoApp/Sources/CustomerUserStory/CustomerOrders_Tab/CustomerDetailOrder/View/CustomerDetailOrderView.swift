//
//  CustomerDetailOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 10/17/23.
//

import SwiftUI
import PhotosUI

struct CustomerDetailOrderView<ViewModel: CustomerDetailOrderViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @Binding var showDetailOrderView: Bool
    
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    @State private var imageGallerySize = UIScreen.main.bounds.width / 2


    init(with viewModel: ViewModel,
         showDetailOrderView: Binding<Bool> ) {
        self.viewModel = viewModel
        self._showDetailOrderView = showDetailOrderView
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    authorSection
                    locationSection
                    dateSection
                    priceSection
                    messageSection
//                    imageSection
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 80)
                .padding(.horizontal)
            }
           
            
            Spacer()
//            addPhotoButton
        }
    }
    
    private var authorSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.photographer())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.order.authorName ?? "") \(viewModel.order.authorSecondName ?? "")")
                .font(.title2.bold())
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var locationSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.location())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.order.authorLocation ?? "")")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var dateSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.date_detail())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            HStack (spacing: 12) {
                HStack(spacing: 2) {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray1.name))
                    Text(viewModel.formattedDate(date: viewModel.order.orderShootingDate, format: "dd MMMM"))
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
                if let time = viewModel.sortedDate(array: viewModel.order.orderShootingTime ?? []).first{
                    HStack(spacing: 2){
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray1.name))
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray3.name))
                    }
                }
                HStack(spacing: 2){
                    Image(systemName: "timer")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray1.name))
                    Text("\(viewModel.order.orderShootingDuration ?? "")")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
            }
        }
    }
    private var priceSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.total_price())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(viewModel.order.orderPrice ?? "")\(viewModel.currencySymbol(for: viewModel.order.authorRegion ?? ""))")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var messageSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.message())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
               
            Text(viewModel.order.customerDescription ?? "")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
                
              
        }
    }
    /*
     // TODO: Сделать добавление Изображений из Portfolio
     
    private var imageSection: some View {
        VStack{
            if viewModel.portfolioImages.count > 0 {
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 0){
                        ForEach(viewModel.portfolioImages.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, image in
                            if let image = image {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageGallerySize, height: imageGallerySize)
                                        .border(Color.white)
                                        .clipped()
                                    
                                        .contextMenu {
                                               Button {
                                                   Task{
                                                       do {
                                                           try await viewModel.deletePortfolioImage(pathKey: key)
                                                           print(key)
                                                       } catch  {
                                                           print(error.localizedDescription)
                                                       }
                                                   }
                                                   print("Deleting Image \(key)")
                                               } label: {
                                                   Label(R.string.localizable.portfolio_delete_image(), systemImage: "trash")
                                               }
                                           }
                                }
                            }
                        }
                    }

                }
            } else {
                if viewModel.smallImagesPortfolio.count > 0 {
                    VStack{
                        ProgressView()
                            .padding(.top, 120)
                    }
                } else {
                    VStack{
                        Spacer()
                        Text(R.string.localizable.portfolio_add_images())
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray3.name))
                            .multilineTextAlignment(.center)
                            .padding(36)
                            .padding(.top, 120)
                    }
                }
            }
        }
    }
    private var addPhotoButton: some View {
        PhotosPicker(selection: $selectedPhotos,
                     maxSelectionCount: 10,
                     matching: .any(of: [.images, .not(.videos)]),
                     preferredItemEncoding: .automatic,
                     photoLibrary: .shared()) {
            ZStack {
                Capsule()
                    .foregroundColor(Color(R.color.gray1.name))
                    .frame(height: 50)
                HStack{
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color(R.color.gray6.name))
                    Text(R.string.localizable.customer_order_add_sample())
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(R.color.gray6.name))
                }
            }
            .padding(16)
        }
    }
     */
     
}

struct CustomerDetailOrderView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()

    static var previews: some View {
        CustomerDetailOrderView(with: modelMock, showDetailOrderView: .constant(false))
    }
}

private class MockViewModel: CustomerDetailOrderViewModelType, ObservableObject {
     
    func currencySymbol(for regionCode: String) -> String {
        "$"
    }
    var portfolioImages: [String: UIImage?] = [:]
    var smallImagesPortfolio: [String] = []

    func formattedDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }
    func getPortfolioImages(imagesPath: [String]) async throws {}
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws {}
    func deletePortfolioImage(pathKey: String) async throws {}
    
    var order: DbOrderModel = DbOrderModel(order: OrderModel(orderId: "", orderCreateDate: Date(), orderPrice: "5500", orderStatus: "Umpcoming", orderShootingDate: Date(), orderShootingTime: ["11:30"], orderShootingDuration: "2", orderSamplePhotos: [""], orderMessages: nil, authorId: "", authorName: "Author", authorSecondName: "SecondName", authorLocation: "Phuket, Thailand", customerId: "", customerName: "customerName", customerSecondName: "customerSecondName", customerDescription: "Customer Description and Bla bla bla", customerContactInfo: DbContactInfo(instagramLink: "", phone: "", email: ""), instagramLink: ""))
    
    
}

