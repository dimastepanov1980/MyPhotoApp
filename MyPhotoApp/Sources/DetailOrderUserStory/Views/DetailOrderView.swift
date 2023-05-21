//
//  DetailOrderView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/20/23.
//

import SwiftUI

struct DetailOrderView<ViewModel: DetailOrderViewModelType>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @State private var showingOptions = false
    @State private var selection = "None"
    @State private var randomHeights: [CGFloat] = []

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
                    }
                    
                }
                ButtonXl(titleText: R.string.localizable.addPhoto(), iconName: "plus.circle") {
                    //
                }
            }
        } 
        
        .navigationBarTitle(Text(viewModel.name), displayMode: .inline)
        .navigationBarItems(leading:
                                HStack {
            Button {
                //
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
        VStack(alignment: .leading, spacing: 0) {
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
                Image(R.image.ic_time.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                Text(viewModel.date.formatted(.dateTime.hour(.conversationalDefaultDigits(amPM: .omitted)).minute()))
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray3.name))
                    .padding(.trailing, 16)
                
                Image(R.image.ic_time.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                Text(String(format: "%.1f", viewModel.duration))
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
                if let content = viewModel.instagramLink {
                    Button {
                        print("Instagramm")
                    } label: {
                        Image(content)
                    }
                }
       
            }.padding(.top,16)
        }.padding(.horizontal, 16)
    }
    
    private var imageSection: some View {
        HStack(alignment: .top) {
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
    func formattedDate() -> String {
        return "04 September"
    }
    
    @Published var name = "Marat Olga"
    @Published var instagramLink: String? = ""
    @Published var price: Int? = 5500
    @Published var place: String? = "Kata Noy Beach"
    @Published var description: String? = "Нет возможности делать промоакции. Нет возможноcти предлагать кросс услуги (аренда одежды, мейкап итд). Нет возможности оставлять заметки о предстоящей фотосессии. Смотреть погоду, Нет возможности оставлять заметки о предстоящей фотосессии. Смотреть погоду"
    @Published var duration = 1.5
    @Published var image: String? = ""
    @Published var date: Date = Date()
    
    @Published var images: [imageModel] = [
        imageModel(imageName: R.image.image0.name),
        imageModel(imageName: R.image.image1.name),
        imageModel(imageName: R.image.image2.name),
        imageModel(imageName: R.image.image3.name),
        imageModel(imageName: R.image.image4.name),
        imageModel(imageName: R.image.image5.name),
        imageModel(imageName: R.image.image6.name),
        imageModel(imageName: R.image.image7.name),
        imageModel(imageName: R.image.image8.name),
        imageModel(imageName: R.image.image9.name)
    ]
    
    func addImage(_ image: String) {
        //
    }
}
