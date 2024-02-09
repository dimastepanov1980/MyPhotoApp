//
//  AuthorDetailOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 1/24/24.
//

import SwiftUI
import PhotosUI
import Firebase
import UniformTypeIdentifiers

struct AuthorDetailOrderView: View {
    var index: Int
    var orderId: String {
        return authorOrders.authorOrders[index].orderId
    }
    var orderSamplePhotos: [String] {
        authorOrders.authorOrders[index].orderSamplePhotos
    }
    
    @ObservedObject private var viewModel = AuthorDetailOrderViewModel()
    
    @EnvironmentObject var router: Router<Views>
    @EnvironmentObject var authorOrders: AuthorMainScreenViewModel
    
    
    @State private var selectedStatus = ""
    @State private var selectImages: [PhotosPickerItem] = []
    @State var showChangeStatusSheet: Bool = false
    @State var isCopied: Bool = false
    @State var isCanceled: Bool = false
    @State var statusIsChange: Bool = false
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    @State private var imageGallerySize = UIScreen.main.bounds.width / 3
    
    init(index: Int) {
        self.index = index
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
                ZStack(alignment: .center){
                    if isCopied {
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
                        contactSection
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
                        router.push(.MessagerView(title: "\(authorOrders.authorOrders[index].customerName ?? "") \(authorOrders.authorOrders[index].customerSecondName ?? "")" , orderId: authorOrders.authorOrders[index].orderId))
                    } label: {

                        if authorOrders.authorOrders[index].newMessagesAuthor > 0 {
                                ZStack{
                                    Image(systemName: "message")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 22)
                                        .foregroundColor(Color(R.color.gray2.name))
                                    
                                    Text(String(authorOrders.authorOrders[index].newMessagesAuthor))
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(.systemBackground))
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background((Color(R.color.red.name)))
                                        .cornerRadius(15)
                                        .offset(x: 12, y: 5)
                                }
                            } else {
                                Image(systemName: "message")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 22)
                                    .foregroundColor(Color(R.color.gray2.name))
                            }
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
                                             try await viewModel.addReferenceImages(selectedImages: image, orderId: orderId)
                                         } catch {
                                             print("Error uploading images: \(error)")
                                             throw error
                                         }
                                     }
                                 })
                                 .disabled( viewModel.smallReferenceImages.count > 20 )
                    Button {
                        router.push(.AuthorAddOrderView(order: authorOrders.authorOrders[index], mode: .edit))
                    } label: {
                        Image(systemName: "pencil.line")
                    }                    }
                .foregroundColor(Color(R.color.gray2.name))
                .padding()
            }
        }
        .onAppear{
            Task {
                try await viewModel.getReferenceImages(imagesPath: orderSamplePhotos)
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
                            if let orderShootingTime = authorOrders.authorOrders[index].orderShootingTime {
                                for time in orderShootingTime {
                                    try await UserManager.shared.removeTimeSlotFromBookingDay(userId: authorOrders.authorOrders[index].authorId ?? "", selectedDay: viewModel.formattedDate(date: authorOrders.authorOrders[index].orderShootingDate, format: "YYYYMMdd"), selectedTime: time)
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
                try await viewModel.updateStatus(status: viewModel.returnedStatus(status: selectedStatus), orderId: orderId)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button {
                                    router.pop()
                                } label: {
                                    Image(systemName: "chevron.left.circle.fill")
                                       .font(.title2)
                                       .foregroundStyle(Color(.systemBackground), Color(R.color.gray1.name).opacity(0.5))
                                }
        )
    }
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(R.string.localizable.order_customer())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            HStack{
                Text("\(authorOrders.authorOrders[index].customerName ?? "") \(authorOrders.authorOrders[index].customerSecondName ?? "")")
                    .font(.title2.bold())
                    .foregroundColor(Color(R.color.gray2.name))
                Spacer()
              
                    VStack(alignment: .trailing) {
//                        if !viewModel.status.isEmpty {
                            Button {
                                    showChangeStatusSheet.toggle()
                            } label: {
                                Text(viewModel.lacalizationStatus(orderStatus: authorOrders.authorOrders[index].orderStatus))
                                    .font(.caption2)
                                    .foregroundColor(Color(.systemBackground))
                                    .padding(.horizontal,10)
                                    .padding(.vertical, 5)
                                    .background(viewModel.statusColor(status: authorOrders.authorOrders[index].orderStatus))
                                    .cornerRadius(15)
                            }
//                        }
                    }
            }
        }
    }
    private var locationSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.location())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
            Text("\(authorOrders.authorOrders[index].authorLocation ?? "")")
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
                    Text(viewModel.formattedDate(date: authorOrders.authorOrders[index].orderShootingDate, format: "dd MMMM"))
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
                if let time = viewModel.sortedDate(array: authorOrders.authorOrders[index].orderShootingTime ?? []).first{
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
                    Text("\(authorOrders.authorOrders[index].orderShootingDuration)")
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
            Text("\(authorOrders.authorOrders[index].orderPrice ?? "") \(viewModel.currencySymbol(for: authorOrders.authorOrders[index].authorRegion ?? ""))")
                .font(.body)
                .foregroundColor(Color(R.color.gray2.name))
        }
    }
    private var messageSection: some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.message())
                .font(.caption2)
                .foregroundColor(Color(R.color.gray4.name))
               
            Text(authorOrders.authorOrders[index].customerDescription ?? "")
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
               
                if let instagramLink = authorOrders.authorOrders[index].customerContactInfo.instagramLink {
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
                if let phone = authorOrders.authorOrders[index].customerContactInfo.phone {
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
                if let email = authorOrders.authorOrders[index].customerContactInfo.email {
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
                                                           try await viewModel.deleteReferenceImages(pathKey: key, orderId: orderId)
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
