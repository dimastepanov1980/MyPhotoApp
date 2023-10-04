//
//  PortfolioAddImagesView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/12/23.
//

import SwiftUI
import PhotosUI

struct PortfolioView<ViewModel: PortfolioViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var showPortfolioEditView: Bool = false
    @State private var showingOptions = false
    @State private var selectPortfolioImages: [PhotosPickerItem] = []
    @State private var selectPortfolioImagesData: [Data]? = []
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    
    @State private var imageGallerySize = UIScreen.main.bounds.width / 3
    
    init(with viewModel : ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                authorSection
                    .padding(.horizontal, 24)
                imageSection
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    
                    PhotosPicker(selection: $selectPortfolioImages,
                                 maxSelectionCount: 10,
                                 matching: .any(of: [.images, .not(.videos)]),
                                 preferredItemEncoding: .automatic,
                                 photoLibrary: .shared()) {
                        Image(systemName: "plus.app")
                    }
                                 .onChange(of: selectPortfolioImages, perform: { images in
                                                  Task {
                                                      do {
                                                          print("uploading images:")
                                                          selectPortfolioImages = []
                                                          try await viewModel.addPortfolioImages(selectedImages: images)
                                                          viewModel.avatarAuthorID = UUID()
                                                      } catch {
                                                          print("Error uploading images: \(error)")
                                                          throw error
                                                      }
                                                 }
                                              })

                    .disabled( viewModel.smallImagesPortfolio.count > 10 )
                    
                    Button {
                        showPortfolioEditView.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                    }
                }
                .foregroundColor(Color(R.color.gray2.name))
                .padding()
            }
        }
        .navigationDestination(isPresented: $showPortfolioEditView) {
            PortfolioEditView(with: PortfolioEditViewModel(locationAuthor: viewModel.locationAuthor,
                                                           typeAuthor: $viewModel.typeAuthor,
                                                           nameAuthor: $viewModel.nameAuthor,
                                                           avatarAuthorID: $viewModel.avatarAuthorID,
                                                           avatarURL: $viewModel.avatarURL,
                                                           familynameAuthor: $viewModel.familynameAuthor,
                                                           sexAuthor: $viewModel.sexAuthor,
                                                           ageAuthor: $viewModel.ageAuthor,
                                                           styleAuthor: $viewModel.styleAuthor,
                                                           avatarAuthor: $viewModel.avatarAuthor,
                                                           descriptionAuthor: $viewModel.descriptionAuthor,
                                                           longitude: $viewModel.longitude,
                                                           latitude: $viewModel.latitude,
                                                           regionAuthor: $viewModel.regionAuthor))
        }
        .onAppear{
            Task {
                try await viewModel.getAuthorPortfolio()
                viewModel.updatePreview()
                try await viewModel.getPortfolioImages(imagesPath: viewModel.smallImagesPortfolio)
            }
        }
    }
    
    private var authorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                AsyncImage(url: URL(string: viewModel.avatarAuthor)){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ZStack{
                        ProgressView()
                        Color.gray.opacity(0.2)
                        
                    }
                }.mask {
                    Circle()
                }
                .frame(width: 68, height: 68)
                .id(viewModel.avatarAuthorID)
                
                
                VStack(alignment: .leading){
                    Text("\(viewModel.nameAuthor) \(viewModel.familynameAuthor)")
                        .font(.title2.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                    Text("\(viewModel.locationAuthor)")
                        .font(.callout)
                        .foregroundColor(Color(R.color.gray4.name))
                }
                .padding(12)
                
            }
            
            HStack(spacing: 16){
                ForEach(viewModel.styleAuthor, id: \.self) { genre in
                    HStack{
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Color(R.color.gray4.name))
                            .frame(width: 20, height: 20)
                        Text(genre)
                            .font(.caption2)
                            .foregroundColor(Color(R.color.gray4.name))
                    }
                }
            }
            Divider()
            
            Text(viewModel.descriptionAuthor)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
        }
        .padding(.top, 24)
        
    }
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
    
}

struct PortfolioAddImagesView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    
    static var previews: some View {
        NavigationStack{
            PortfolioView(with: viewModel)
        }
    }
}

private class MockViewModel: PortfolioViewModelType, ObservableObject {
    func deletePortfolioImage(pathKey: String) async throws {}
    func addPortfolioImages(selectedImages: [PhotosPickerItem]) async throws {}
    var portfolioImages: [String : UIImage?] = [:]
    var regionAuthor: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var identifier: String = ""
    var smallImagesPortfolio: [String] = []
    func getPortfolioImages(imagesPath: [String]) async throws {}
    var typeAuthor: String = "photo"
    var selectedAvatar: PhotosPickerItem?
    var avatarAuthorID = UUID()
    var avatarURL: URL?
    func avatarPathToURL(path: String) async throws -> URL {
        URL(string: "")!
    }
    
    var sexAuthorList: [String] = ["Select", "Male", "Female"]
    var dbModel: DBPortfolioModel?
    var styleOfPhotography: [String] = ["Aerial", "Architecture", "Documentary", "Event", "Fashion", "Food", "Love Story", "Macro", "People", "Pet", "Portraits", "Product", "Real Estate", "Sports", "Wedding", "Wildlife"]
    var locationAuthor: String = "Phuket, Thailand"
    var locationResult: [DBLocationModel] = []
    var avatarAuthor: String = "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"
    var nameAuthor: String = "Iryna"
    var familynameAuthor: String = "Bocharova"
    var ageAuthor: String = "27"
    var sexAuthor: String = "Female"
    var styleAuthor: [String]  = ["Aerial", "Architecture", "Documentary", "Sports"]
    var descriptionAuthor: String  = "Swift, SwiftUI, the Swift logo, Swift Playgrounds, Xcode, Instruments, Cocoa Touch, Touch ID, AirDrop, iBeacon, iPhone, iPad, Safari, App Store, watchOS, tvOS, Mac and macOS are trademarks of Apple Inc., registered in the U.S. and other countries. Pulp Fiction is copyright © 1994 Miramax Films. Hacking with Swift is ©2023 Hudson Heavy Industries."
    func updatePreview() {}
    func getAuthorPortfolio() async throws {}
}
