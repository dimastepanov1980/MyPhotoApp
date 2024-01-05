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
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var user: UserTypeService
    
    @State private var selectedStatus = ""
    @State private var selectImages: [PhotosPickerItem] = []
    @State var showChangeStatusSheet: Bool = false
    @State var isCopied: Bool = false
    @State var isCanceled: Bool = false
    @State var statusIsChange: Bool = false
    @State private var selectedImageURL: URL?
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    @State private var imageGallerySize = UIScreen.main.bounds.width / 3

    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
                ZStack(alignment: .center){
                    if isCopied {
                    // Shows up only when copy is done
                        Text(R.string.localizable.copied())
                            .foregroundColor(Color(.systemBackground))
                            .bold()
                            .font(.footnote)
                            .padding(12)
                            .background(Color(R.color.gray2.name).opacity(0.8).cornerRadius(21))
                    }
                    
                    VStack(alignment: .leading, spacing: 18) {
                        nameSection
                        locationSection
                        dateSection
                        priceSection
                        if user.userType == .author {
                            contactSection
                        }
                        messageSection
                        imageSection
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal)
                }
            }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Button {
                        router.push(.MessagerView(title: user.userType == .author ? "\(viewModel.order.customerName ?? "") \(viewModel.order.customerSecondName ?? "")" : "\(viewModel.order.authorName ?? "") \(viewModel.order.authorSecondName ?? "")", orderId: viewModel.order.orderId))
                    } label: {
                        Image(systemName: "bubble.left")
                    }
                    
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
                        router.push(.AuthorAddOrderView(order: viewModel.order, mode: .edit))
                    } label: {
                        Image(systemName: "pencil.line")
                    }                    }
                .foregroundColor(Color(R.color.gray2.name))
                .padding()
            }
        }
        .onAppear{
            Task {
                if let images = viewModel.order.orderSamplePhotos {
                    try await viewModel.getReferenceImages(imagesPath: images)
                }
            }
        }
        .confirmationDialog("Change Status", isPresented: $showChangeStatusSheet) {
            ForEach(viewModel.avaibleStatus, id: \.self) { status in
                Button(status) {
                    switch status {
                    case "Canceled":
                        isCanceled = true
                        statusIsChange = false
                    default:
                        self.selectedStatus = status
                        viewModel.status = status
                        statusIsChange = true
                    }
                    
                }
            }
        }
        .alert( R.string.localizable.status_canceled_warning(),
                isPresented: $isCanceled
        ) {
            HStack{
                Button("Cancel", role: .cancel) {
                    
                }
                
                Button("Ok", role: .destructive) {
                    Task {
                        do{
                            if let orderShootingTime = viewModel.order.orderShootingTime {
                                for time in orderShootingTime {
                                    try await UserManager.shared.removeTimeSlotFromBookingDay(userId: viewModel.order.authorId ?? "", selectedDay: viewModel.formattedDate(date: viewModel.order.orderShootingDate, format: "YYYYMMdd"), selectedTime: time)
                                }
                            }
                            self.viewModel.status = "Canceled"
                            self.statusIsChange = true
                        } catch {
                            throw error
                        }
                        
                    }
                }
                
            }
        }
        .onChange(of: statusIsChange) { _ in
            Task {
                let userOrders = DbOrderModel(order:
                                                OrderModel(orderId: viewModel.order.orderId,
                                                           orderCreateDate: Date(),
                                                           orderPrice: viewModel.order.orderPrice,
                                                           orderStatus: viewModel.returnedStatus(status: selectedStatus),
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
                                                           customerContactInfo: ContactInfo(instagramLink: nil, phone: nil, email: nil)))
                try await viewModel.updateStatus(orderModel: userOrders)
                print(selectedStatus)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView())
        
    }
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(user.userType == .customer ? R.string.localizable.order_author() : R.string.localizable.order_customer() )
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            HStack{
                Text(user.userType == .customer ? "\(viewModel.order.authorName ?? "") \(viewModel.order.authorSecondName ?? "")" : "\(viewModel.order.customerName ?? "") \(viewModel.order.customerSecondName ?? "")")
                    .font(.title2.bold())
                    .foregroundColor(Color(R.color.gray2.name))
                Spacer()
              
                    VStack(alignment: .trailing) {
                        if !viewModel.status.isEmpty {
                            Button {
                                    showChangeStatusSheet.toggle()
                            } label: {
                                Text(viewModel.status)
                                    .font(.caption2)
                                    .foregroundColor(Color(.systemBackground))
                                    .padding(.horizontal,10)
                                    .padding(.vertical, 5)
                                    .background(viewModel.statusColor)
                                    .cornerRadius(15)
                            }
                            .disabled(viewModel.status == "Canceled" || user.userType == .customer )
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
            Text("\(viewModel.order.orderPrice ?? "") \(viewModel.currencySymbol(for: viewModel.order.authorRegion ?? ""))")
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
                            Text(instagramLink)
                                .font(.subheadline)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        .onTapGesture {
                            viewModel.openInstagramProfile(username: instagramLink)
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
                                        .border(Color(.systemBackground))
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
                    VStack(alignment: .center){
                        Spacer()
                        ProgressView(R.string.localizable.portfolio_please_wait())
                            .progressViewStyle(.circular)
                    }
                } else {
                    VStack(alignment: .center){
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
        .frame(minWidth: 0, maxWidth: .infinity)
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
            DetailOrderView(with: modelMock)
                .environmentObject(UserTypeService())
        }
    }
}

private class MockViewModel: DetailOrderViewModelType, ObservableObject {
    func openInstagramProfile(username: String) {}
    
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
                                                             orderMessages: false,
                                                             authorId: "",
                                                             authorName: "authorName",
                                                             authorSecondName: "authorSecondName",
                                                             authorLocation: "Phuket, Thailand",
                                                             customerId: "",
                                                             customerName: "Name",
                                                             customerSecondName: "SecondName",
                                                             customerDescription: "Customer Description and Bla bla bla sdfsdf sdfsdf",
                                                             customerContactInfo:
                                                                ContactInfo(instagramLink: "https://instagram.com/fitnessbymaddy_?igshid=MzRlODBiNWFlZA==",
                                                                              phone: "+7 999 99 99",
                                                                              email: "email@email.com")))
    
    var avaibleStatus: [String] = ["Upcoming", "Cancel Order"]
    
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
