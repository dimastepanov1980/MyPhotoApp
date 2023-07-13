//
//  DetailOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI
import Firebase

struct DetailOrderView<ViewModel: DetailOrderViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @State private var showingOptions = false
    @State private var randomHeights: [CGFloat] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding var showEditOrderView: Bool
    @State var showActionSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(with viewModel: ViewModel,
         showEditOrderView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showEditOrderView = showEditOrderView
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom){
                            infoSection
                            Spacer()
                            priceSection
                        }
                            desctriptionSection
                            imageSection
                    }
                    .padding(.top)
                    .padding(.horizontal, 16)
                    
                }
                addPhotoButton
                    .onChange(of: selectedItems) { image in
                        Task {
                            try await viewModel.addReferenceUIImages(selectedItems: image)
                        }
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let instagramLink = viewModel.order.instagramLink, instagramLink.isEmpty {
                    Button(action: {
                        if let url = URL(string: instagramLink) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text(viewModel.order.name ?? "")
                            Image(R.image.ic_instagram.name)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                        }
                    }.foregroundColor(Color(R.color.gray2.name))
                } else {
                    Text(viewModel.order.name ?? "")
                }
            }
        }
        .navigationBarItems(leading: HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
                
            } label: {
                Image(systemName: "chevron.backward.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
            }
            .foregroundColor(Color(R.color.gray2.name))
        },
                            trailing: HStack {
            Button {
                showEditOrderView.toggle()
            } label: {
                Image(R.image.ic_edit.name)
            }
            
        })
        .fullScreenCover(isPresented: $showEditOrderView) {
            NavigationStack {
                AddOrderView(with: AddOrderViewModel(order: viewModel.order), showAddOrderView: $showEditOrderView, mode: .edit)
            }
        }
        .confirmationDialog("Change Status", isPresented: $showActionSheet) {
            ForEach(viewModel.avaibleStatus, id: \.self) { status in
                Button(status) {
                    Task {
//                        try await viewModel.updateStatus(orderModel: <#T##UserOrdersModel#>, status: status)
                    }
                }
            }
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(viewModel.formattedDate(date: viewModel.order.date, format: "dd MMMM"))
                    .font(.title2.bold())
                    .foregroundColor(Color(R.color.gray1.name))
                
                Image(R.image.ic_weater.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
            }
            if let location = viewModel.order.location {
                Text(location)
                    .font(.headline)
                    .foregroundColor(Color(R.color.gray2.name))
            }
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                
                Text(viewModel.order.date.formatted(.dateTime.hour(.conversationalDefaultDigits(amPM: .omitted)).minute()))
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(.trailing, 16)
                
                Image(systemName: "timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                
                if let duration = viewModel.order.duration {
                    Text("\(duration)h")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray3.name))
                }
            }
        }
    }
    private var priceSection: some View {
        VStack(alignment: .trailing) {
            if let status = viewModel.order.status, !status.isEmpty {
                Button {
                        showActionSheet.toggle()
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 25)
                        Text(status)
                            .font(.caption)
                    }
                }
            }
            if let price = viewModel.order.price, !price.isEmpty {
                    Text(R.string.localizable.totalPrice())
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray2.name))
                    Text("\(price) Thb")
                        .font(.headline.bold())
                        .foregroundColor(Color(R.color.gray2.name))
                
            }
        }
    }
    private var desctriptionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let description = viewModel.order.description {
                Text(description)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 24)
            }
        }
    }
    private var imageSection: some View {
        // MARK: https://stackoverflow.com/questions/66101176/how-could-i-use-a-swiftui-lazyvgrid-to-create-a-staggered-grid
        // Сделать в две  строчки
        // Проверить что бы добовлялись изображения
        HStack(alignment: .top) {
            VStack {
                ForEach(viewModel.selectImages, id: \.self) { image in
                  
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 250)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                            
                            Button {
                                showingOptions = true
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color.white)
                            }
                            .padding(16)
                        }
                    
                }
            }
        }
        .task {
            try? await viewModel.fetchImages()
        }
        .confirmationDialog("Remove the image",
                            isPresented: $showingOptions) {
            Button {
                //
            } label: {
                Text("Remove")
                    .foregroundColor(Color.white)
                
            }
        }
    }
    private var addPhotoButton: some View {
        PhotosPicker(selection: $selectedItems,
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
                    Text(R.string.localizable.addPhoto()
                    )
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(R.color.gray6.name))
                }
            }
            .padding(16)
        }
    }

}


struct DetailOrderView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()
    
    static var previews: some View {
        NavigationView {
            DetailOrderView(with: modelMock, showEditOrderView: .constant(false))
        }
    }
}
private class MockViewModel: DetailOrderViewModelType, ObservableObject {
    func updateStatus(orderModel: UserOrdersModel, status: String) async throws {
        //
    }
    
    @Published var avaibleStatus: [String] = ["Upcoming", "In progress", "Completed"]
    @Published var selectImages: [UIImage] = []
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var setImage: [Data] = []
    
    @Published var order: UserOrdersModel = UserOrdersModel(order: newOrder)
    
    private static let newOrder = OrderModel(orderId: "1",
                                             name: "Kata Noy Beach",
                                             instagramLink: "Marat Olga",
                                             price: "5500",
                                             location: "KataNoy",
                                             description: "Нет возможности делать промоакции.",
                                             date: Date(),
                                             duration: "1.5",
                                             imageUrl: [],
                                             status: "Upcoming")

    func fetchImages() async throws {
        //
    }
    func addReferenceUIImages(selectedItems: [PhotosPickerItem]) async throws {
        //
    }
    func addAvatarImage(image: PhotosPickerItem) {
        //
    }
    func formattedDate(date: Date, format: String) -> String {
        return "04 September"
    }
}
