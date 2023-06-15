//
//  DetailOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import SwiftUI
import PhotosUI

struct DetailOrderView<ViewModel: DetailOrderViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var randomHeights: [CGFloat] = []
    @State private var maxSelectedImages: [PhotosPickerItem] = []
    @State private var setImage: [Data] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .trailing) {
                        HStack(alignment: .bottom){
                            infoSection
                            Spacer()
                            priceSection
                        } .padding(.horizontal, 16)
                        
                        desctriptionSection
                        imageSection
                    }.padding(.top)
                    
                }
                addPhotoButton
                    .onChange(of: maxSelectedImages) { image in
                            viewModel.addReferenceImages(images: image)
                    }
            }
        }
        
        .navigationBarTitle(Text(viewModel.name), displayMode: .inline)
        .navigationBarItems(leading:
                                HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
                
            } label: {
                Image(systemName: "chevron.backward.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
            }.foregroundColor(Color(R.color.gray2.name))
        }
                            ,trailing:
                                HStack {
            Button {
                //
            } label: {
                Image(R.image.ic_edit.name)
            }
        })
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(viewModel.formattedDate())
                    .font(.title2.bold())
                    .foregroundColor(Color(R.color.gray1.name))
                
                Image(R.image.ic_weater.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
            }
            
            Text(viewModel.place!)
                .font(.headline)
                .foregroundColor(Color(R.color.gray2.name))
            
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                
                Text(viewModel.date.formatted(.dateTime.hour(.conversationalDefaultDigits(amPM: .omitted)).minute()))
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(.trailing, 16)
                
                Image(systemName: "timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(R.color.gray2.name))
                
                Text(viewModel.duration)
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
            }
        }
    }
    
    private var priceSection: some View {
        VStack {
            if let price = viewModel.price {
                Text(R.string.localizable.totalPrice())
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray2.name))
                Text("\(String(price)) Thb")
                    .font(.headline.bold())
                    .foregroundColor(Color(R.color.gray2.name))
            }
        }
    }
    
    private var desctriptionSection: some View {
        VStack(alignment: .trailing, spacing: 0){
            if let content = viewModel.description {
                Text(content)
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding(.top, 24)
            }
            HStack {
                if let _ = viewModel.instagramLink {
                    Button {
                        print("Instagramm")
                    } label: {
                        Image(R.image.ic_instagram.name)
                    }
                }
            }.padding(.top,16)
        }.padding(.horizontal, 16)
    }
    
    private var imageSection: some View {
            HStack(alignment: .top) {
            VStack {
                ForEach(setImage.prefix(setImage.count / 2), id: \.self) { image in
                    let index = setImage.prefix(setImage.count / 2).firstIndex { $0 == image.self } ?? 0
                    let height = randomHeights.indices.contains(index) ? randomHeights[index] : generateRandomHeight()
                    if let image = UIImage(data: image) {
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
                
            VStack {
                ForEach(setImage.suffix(setImage.count / 2), id: \.self) { image in
                    let index = setImage.suffix(setImage.count / 2).firstIndex { $0 == image.self } ?? 0
                    let height = randomHeights.indices.contains(index) ? randomHeights[index] : generateRandomHeight()
                    if let image = UIImage(data: image) {
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
        }
        .task {
            if let urlString = viewModel.image {
                for item in urlString {
                    do {
                        let data = try await StorageManager.shared.getReferenceImageData(path: item)
                        setImage.append(data)
                    } catch {
                        print("Error fetching image data: \(error)")
                    }
                }
            }
        }
        .padding(8)
        .confirmationDialog("Remove the image",
                            isPresented: $showingOptions,
                            titleVisibility: .visible) {
            Button {
                //
            } label: {
                Text("Remove")
                    .foregroundColor(Color.white)
                
            }
        }.onAppear {
            if randomHeights.isEmpty {
                generateRandomHeights()
            }
        }
    }
    
        /* HStack(alignment: .top) {
            VStack {
                ForEach(viewModel.images.prefix(viewModel.images.count / 2), id: \.id) { image in
                    let index = viewModel.images.prefix(viewModel.images.count / 2).firstIndex { $0.id == image.id } ?? 0
                    let height = randomHeights.indices.contains(index) ? randomHeights[index] : generateRandomHeight()

                    ZStack(alignment: .topTrailing) {
                        Image(image.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: height)
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
            
            VStack {
                ForEach(viewModel.images.suffix(viewModel.images.count / 2), id: \.id) { image in
                    let index = viewModel.images.suffix(viewModel.images.count / 2).firstIndex { $0.id == image.id } ?? 0
                    let height = randomHeights.indices.contains(index) ? randomHeights[index] : generateRandomHeight()

                    ZStack(alignment: .topTrailing) {
                        Image(image.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: height)
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
        .padding(8)
        .confirmationDialog("Remove the image",
                            isPresented: $showingOptions,
                            titleVisibility: .visible) {
            Button {
                //
            } label: {
                Text("Remove")
                    .foregroundColor(Color.white)

            }
        }.onAppear {
            if randomHeights.isEmpty {
                generateRandomHeights()
            }
        }
        */

    
    private var addPhotoButton: some View {
        PhotosPicker(selection: $maxSelectedImages,
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

    private func generateRandomHeights() {
        randomHeights = (0..<viewModel.images.count).map { _ in generateRandomHeight() }
    }

    private func generateRandomHeight() -> CGFloat {
        return CGFloat.random(in: 150...350)
    }
    
}

struct DetailOrderView_Previews: PreviewProvider {
    private static let modelMock = MockViewModel()
    
    static var previews: some View {
        NavigationView {
            DetailOrderView(with: modelMock)
        }
    }
}

private class MockViewModel: DetailOrderViewModelType, ObservableObject {
    func getReferenceImages(path: String) async throws {
        //
    }
    
    func addReferenceImages(images: [PhotosPickerItem]) {
        //
    }
    
    func addAvatarImage(image: PhotosPickerItem) {
        //
    }
    
    func formattedDate() -> String {
        return "04 September"
    }
    
    @Published var name = "Marat Olga"
    @Published var instagramLink: String? = ""
    @Published var price: Int? = 5500
    @Published var place: String? = "Kata Noy Beach"
    @Published var description: String? = "Нет возможности делать промоакции. Нет возможноcти предлагать кросс услуги (аренда одежды, мейкап итд). Нет возможности оставлять заметки о предстоящей фотосессии. Смотреть погоду, Нет возможности оставлять заметки о предстоящей фотосессии. Смотреть погоду"
    @Published var duration = "1.5"
    @Published var image: [String]? = [""]
    @Published var date: Date = Date()
    
    @Published var images: [ImageModel] = [
        ImageModel(imageName: R.image.image0.name),
        ImageModel(imageName: R.image.image1.name),
        ImageModel(imageName: R.image.image2.name),
        ImageModel(imageName: R.image.image3.name),
        ImageModel(imageName: R.image.image4.name),
        ImageModel(imageName: R.image.image5.name),
        ImageModel(imageName: R.image.image6.name),
        ImageModel(imageName: R.image.image7.name),
        ImageModel(imageName: R.image.image8.name),
        ImageModel(imageName: R.image.image9.name)
    ]
}
