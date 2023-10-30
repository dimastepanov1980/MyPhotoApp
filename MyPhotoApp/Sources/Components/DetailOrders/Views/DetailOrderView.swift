//
//  DetailOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import SwiftUI
import PhotosUI
import Firebase
import UniformTypeIdentifiers

struct DetailOrderView<ViewModel: DetailOrderViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    var detailOrderType: DetailOrder

    @State private var showingOptions = false
    @State private var randomHeights: [CGFloat] = []
    @State private var selectImages: [PhotosPickerItem] = []
    @Binding var showEditOrderView: Bool
    @State var showActionSheet: Bool = false
    @State var isCopied: Bool = false
    @State private var selectedImageURL: URL?
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    @State private var imageGallerySize = UIScreen.main.bounds.width / 3
    
    @Environment(\.dismiss) private var dismiss

    init(with viewModel: ViewModel,
         showEditOrderView: Binding<Bool>,
         detailOrderType: DetailOrder) {
        self.viewModel = viewModel
        self._showEditOrderView = showEditOrderView
        self.detailOrderType = detailOrderType
    }
    
    var body: some View {
            ScrollView {
                ZStack(alignment: .center){
                    if isCopied {
                    // Shows up only when copy is done
                        Text(R.string.localizable.copied())
                            .foregroundColor(.white)
                            .bold()
                            .font(.footnote)
                            .padding(12)
                            .background(Color(R.color.gray2.name).opacity(0.8).cornerRadius(21))
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        nameSection
                        locationSection
                        dateSection
                        priceSection
                        if detailOrderType == .author {
                            contactSection
                        }
                        messageSection
                        imageSection
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    
                }

            }

            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        
                        PhotosPicker(selection: $selectImages,
                                     maxSelectionCount: 10,
                                     matching: .any(of: [.images, .not(.videos)]),
                                     preferredItemEncoding: .automatic,
                                     photoLibrary: .shared()) {
                            Image(systemName: "plus.app")
                        }
                                     .onChange(of: selectImages, perform: { image in
                                                      Task {
                                                          do {
                                                              print("uploading images:")
                                                              selectImages = []
                                                              try await viewModel.addReferenceImages(selectedImages: image)
                                                          } catch {
                                                              print("Error uploading images: \(error)")
                                                              throw error
                                                          }
                                                     }
                                                  })

                        .disabled( viewModel.smallReferenceImages.count > 20 )
                        
                        Button {
                            showEditOrderView.toggle()
                        } label: {
                            Image(systemName: "pencil.line")
                        }
                    }
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                        
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")// set image here
                           .font(.title)
                           .foregroundStyle(.white, Color(R.color.gray1.name).opacity(0.7))
                    }
                    
                }
            }
            .onAppear{
                Task {
                    if let images = viewModel.order.orderSamplePhotos {
                        try await viewModel.getReferenceImages(imagesPath: images)
                    }
                }
            }

        .fullScreenCover(isPresented: $showEditOrderView) {
            NavigationStack {
                AuthorAddOrderView(with: AuthorAddOrderViewModel(order: viewModel.order), showAddOrderView: $showEditOrderView, mode: .edit)
            }
        }
        .confirmationDialog("Change Status", isPresented: $showActionSheet) {
            ForEach(viewModel.avaibleStatus, id: \.self) { status in
                Button(status) {
                    Task {
                        self.viewModel.status = status
                        let userOrders = DbOrderModel(order:
                                OrderModel(orderId: viewModel.order.orderId,
                                           orderCreateDate: Date(),
                                           orderPrice: viewModel.order.orderPrice,
                                           orderStatus: viewModel.returnedStatus(status: viewModel.status),
                                           orderShootingDate: viewModel.order.orderShootingDate,
                                           orderShootingTime: viewModel.order.orderShootingTime,
                                           orderShootingDuration: viewModel.order.orderShootingDuration ?? "",
                                           orderSamplePhotos: viewModel.order.orderSamplePhotos ?? [],
                                           orderMessages: viewModel.order.orderMessages,
                                           authorId: viewModel.order.authorId,
                                           authorName: viewModel.order.authorName,
                                           authorSecondName: viewModel.order.authorSecondName,
                                           authorLocation: viewModel.order.authorLocation ?? "",
                                           customerId: nil,
                                           customerName: nil,
                                           customerSecondName: nil,
                                           customerDescription: viewModel.order.customerDescription,
                                           customerContactInfo: DbContactInfo(instagramLink: nil, phone: nil, email: nil)))

                        try await viewModel.updateStatus(orderModel: userOrders)
                    }
                }
            }
        }
        
    }
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(detailOrderType == .customer ? R.string.localizable.photographer() : R.string.localizable.customer() )
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            HStack{
                Text(detailOrderType == .customer ? "\(viewModel.order.authorName ?? "") \(viewModel.order.authorSecondName ?? "")" : "\(viewModel.order.customerName ?? "") \(viewModel.order.customerSecondName ?? "")")
                    .font(.title2.bold())
                    .foregroundColor(Color(R.color.gray2.name))
                Spacer()
                if detailOrderType == .author {
                    VStack(alignment: .trailing) {
                        if !viewModel.status.isEmpty {
                            Button {
                                showActionSheet.toggle()
                            } label: {
                                Text(viewModel.status)
                                    .font(.caption2)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal,10)
                                    .padding(.vertical, 5)
                                    .background(viewModel.statusColor)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
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
    private var contactSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.contact_information())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            VStack(alignment: .leading, spacing: 10){
               
                    if let instagramLink = viewModel.order.customerContactInfo.instagramLink {
                        HStack{
                            Image("image_instagram")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 22, height: 22)
                                .foregroundColor(Color(R.color.gray2.name))
                            Text(R.string.localizable.tap_to_open())
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        .onTapGesture {
                            guard let instagram = URL(string:instagramLink) else { return }
                            UIApplication.shared.open(instagram)
                        }
                    }
                    if let phone = viewModel.order.customerContactInfo.phone {
                        HStack{
                            Image(systemName: "phone.circle")
                                .font(.title3)
                                .foregroundColor(Color(R.color.gray2.name))
                            Text(phone)
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        .onTapGesture {
                            let clipboard = UIPasteboard.general
                            clipboard.setValue(phone, forPasteboardType: UTType.plainText.identifier)
                            withAnimation {
                                isCopied = true
                            }
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                                withAnimation {
                                    isCopied = false
                                }
                            }
                        }
                        
                    }
                    if let email = viewModel.order.customerContactInfo.email {
                        HStack{
                            Image(systemName: "envelope")
                                .font(.title3)
                                .foregroundColor(Color(R.color.gray2.name))
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        .onTapGesture {
                            let clipboard = UIPasteboard.general
                            clipboard.setValue(email, forPasteboardType: UTType.plainText.identifier)
                            withAnimation {
                                isCopied = true
                            }
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                                withAnimation {
                                    isCopied = false
                                }
                            }
                        }
                        
                    }
                }
            }
        
    }
    private var imageSection: some View {
        VStack(alignment: .center){
            if viewModel.referenceImages.count > 0 {
                    LazyVGrid(columns: columns, spacing: 0){
                        ForEach(viewModel.referenceImages.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, image in
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
                                                           try await viewModel.deleteReferenceImages(pathKey: key)
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

            } else {
                if viewModel.smallReferenceImages.count > 0 {
                        ProgressView()
                            .padding(.top, 120)
                } else {
                        Text(R.string.localizable.customer_order_add_sample())
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray3.name))
                            .multilineTextAlignment(.center)
                            .padding(36)
                            .padding(.top, 120)
                    
                }
            }
        }
    }
    private func timeToMinutes(_ time: String) -> Int {
        let components = time.split(separator: ":")
        if components.count == 2, let hours = Int(components[0]), let minutes = Int(components[1]) {
            return hours * 60 + minutes
        }
        return 0
    }
}

struct DetailOrderView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()
    
    static var previews: some View {
        NavigationView {
            DetailOrderView(with: modelMock, showEditOrderView: .constant(false), detailOrderType: .author)
        }
    }
}

private class MockViewModel: DetailOrderViewModelType, ObservableObject {
    var smallReferenceImages: [String] = []
    var referenceImages: [String : UIImage?] = [:]
    func addReferenceImages(selectedImages: [PhotosPickerItem]) async throws {}
    func deleteReferenceImages(pathKey: String) async throws {}
    func getReferenceImages(imagesPath: [String]) async throws {}
    func currencySymbol(for regionCode: String) -> String{
        "$"
    }
    func sortedDate(array: [String]) -> [String] {
        array.sorted(by: { $0 < $1 })
    }

    var order: DbOrderModel = DbOrderModel(order: OrderModel(orderId: "",
                                                             orderCreateDate: Date(),
                                                             orderPrice: "5500",
                                                             orderStatus: "Umpcoming",
                                                             orderShootingDate: Date(),
                                                             orderShootingTime: ["11:30"],
                                                             orderShootingDuration: "2",
                                                             orderSamplePhotos: [""],
                                                             orderMessages: nil,
                                                             authorId: "",
                                                             authorName: "authorName",
                                                             authorSecondName: "authorSecondName",
                                                             authorLocation: "Phuket, Thailand",
                                                             customerId: "",
                                                             customerName: "customerName",
                                                             customerSecondName: "customerSecondName",
                                                             customerDescription: "Customer Description and Bla bla bla sdfsdf sdfsdf",
                                                             customerContactInfo:
                                                                DbContactInfo(instagramLink: "https://instagram.com/fitnessbymaddy_?igshid=MzRlODBiNWFlZA==",
                                                                              phone: "+7 999 99 99",
                                                                              email: "email@email.com")))
    
    var avaibleStatus: [String] = []
    
    var status: String = "Upcoming"
    
    var statusColor: Color = .blue
    
    func formattedDate(date: Date, format: String) -> String {
        "10 Октября"
    }
    
    func updateStatus(orderModel: DbOrderModel) async throws {
        
    }
    
    func returnedStatus(status: String) -> String {
        ""
    }
}
