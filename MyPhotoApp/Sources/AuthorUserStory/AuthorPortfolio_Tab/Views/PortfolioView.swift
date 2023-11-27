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
    @State private var showScheduleView = false
    @State private var selectPortfolioImages: [PhotosPickerItem] = []
    @State private var selectPortfolioImagesData: [Data]? = []
    @State private var columns = [ GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0),
                                   GridItem(.flexible(), spacing: 0)]
    
    @State private var imageGallerySize = UIScreen.main.bounds.width / 3
    @Binding var path: NavigationPath

    init(with viewModel : ViewModel,
         path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    authorSection
                        .padding(.horizontal, 24)
                    imageSection
                }
            }
            .onAppear{
                print("PortfolioView Path Count: \(path.count)")
            }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 20){
                    
                    if let portfolio = viewModel.dbModel {
                        
                        PhotosPicker(selection: $selectPortfolioImages,
                                     maxSelectionCount: 10,
                                     matching: .any(of: [.images, .not(.videos)]),
                                     preferredItemEncoding: .automatic,
                                     photoLibrary: .shared()) {
                            Image(systemName: "plus.app")
                                .font(.headline)
                                .fontWeight(.light)
                                .foregroundColor(Color(R.color.gray2.name))
                        }
                            .onChange(of: selectPortfolioImages, perform: { images in
                                Task {
                                    do {
                                        print("uploading images:")
                                        selectPortfolioImages = []
                                        try await viewModel.addPortfolioImages(selectedImages: images)
                                    } catch {
                                        print("Error uploading images: \(error)")
                                        throw error
                                    }
                                }
                            })
                            .disabled( viewModel.smallImagesPortfolio.count > 60 )
                        
                        if let schedule = portfolio.schedule, schedule.isEmpty {
                            Button {
                                showScheduleView.toggle()
                            } label: {
                                Image(systemName: "calendar")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundStyle(Color(R.color.gray2.name))
                                    .overlay {
                                        ZStack{
                
                                            Circle()
                                                .frame(width: 18)
                                                .foregroundStyle(Color(R.color.red.name))
                                            
                                            Text("!")
                                                .font(.callout)
                                                .fontWeight(.heavy)
                                                .foregroundColor(Color(R.color.gray7.name))
                                               
                                        } .offset(x: 10, y: 10)
                                    }
                            }
                        } else {
                            Button {
                                showScheduleView.toggle()
                            } label: {
                                Image(systemName: "calendar")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(R.color.gray2.name))
                            }
                        }
                    }
                    Button {
                        showPortfolioEditView.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color(R.color.gray2.name))
                    }
                }
                .padding()
            }
        }
        
        // TODO: - DBPortfolioModel заменить на PortfolioModel и прокинуть что бы была нормльная навигация
        .navigationDestination(isPresented: $showPortfolioEditView) {
            PortfolioEditView(with: PortfolioEditViewModel(locationAuthor: viewModel.locationAuthor,
                                                           typeAuthor: $viewModel.typeAuthor,
                                                           nameAuthor: $viewModel.nameAuthor,
                                                           familynameAuthor: $viewModel.familynameAuthor,
                                                           sexAuthor: $viewModel.sexAuthor,
                                                           ageAuthor: $viewModel.ageAuthor,
                                                           styleAuthor: $viewModel.styleAuthor,
                                                           avatarAuthor: viewModel.avatarAuthor,
                                                           avatarImage: viewModel.avatarImage ?? nil,
                                                           descriptionAuthor: $viewModel.descriptionAuthor,
                                                           longitude: $viewModel.longitude,
                                                           latitude: $viewModel.latitude,
                                                           regionAuthor: $viewModel.regionAuthor),
                                                            path: $path)
        }
        .navigationDestination(isPresented: $showScheduleView) {
            PortfolioScheduleView(with: PortfolioScheduleViewModel(), showScheduleView: $showScheduleView, path: $path)
                .onAppear { UIDatePicker.appearance().minuteInterval = 30 }
        }
        .onAppear{
            Task {
                try await viewModel.getAuthorPortfolio()
                viewModel.updatePreview()

                try await viewModel.getAvatarImage(imagePath: viewModel.avatarAuthor)
                
                try await viewModel.getPortfolioImages(imagesPath: viewModel.smallImagesPortfolio)
            }
        }
    }
    
    private var authorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack{
                if let avatarImage = viewModel.avatarImage {
                    
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFill()
                        .mask {
                            Circle()
                        }
                        .frame(width: 68, height: 68)
                } else {
                    ZStack{
                        Color(R.color.gray5.name)
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                            .foregroundColor(Color(R.color.gray3.name))
                            
                    }
                    .mask {
                        Circle()
                    }
                    .frame(width: 68, height: 68)
                }
                
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
                        Image(systemName: imageStyleAuthor(genre: genre))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Color(R.color.gray2.name))
                            .frame(width: 15, height: 15)
                        
                        Text(genre)
                            .font(.caption2)
                            .foregroundColor(Color(R.color.gray3.name))
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
                        VStack(alignment: .center){
                            Spacer()
                            ProgressView(R.string.localizable.portfolio_please_wait())
                                .progressViewStyle(.circular)
                        }
                    } else {
                        if viewModel.dbModel == nil {
                            VStack(spacing: 0){
                                Text(R.string.localizable.portfolio_setup_portfolio())
                                    .font(.subheadline)
                                    .foregroundColor(Color(R.color.gray3.name))
                                    .multilineTextAlignment(.center)
                                    .padding(36)
                                    .padding(.top, 120)
                                Button {
                                    showPortfolioEditView = true
                                } label: {
                                    Text(R.string.localizable.portfolio_setup_portfolio_btt())
                                        .font(.headline)
                                        .foregroundColor(Color(R.color.gray6.name))
                                        .padding(8)
                                        .padding(.horizontal, 16)
                                        .background(Color(R.color.gray1.name))
                                        .cornerRadius(20)
                                }
                            }
                        } else {
                            VStack{
                                Text(R.string.localizable.portfolio_add_images())
                                    .font(.subheadline)
                                    .foregroundColor(Color(R.color.gray3.name))
                                    .multilineTextAlignment(.center)
                                    .padding(36)
                                    .padding(.top, 120)
                                
                                PhotosPicker(selection: $selectPortfolioImages,
                                             maxSelectionCount: 10,
                                             matching: .any(of: [.images, .not(.videos)]),
                                             preferredItemEncoding: .automatic,
                                             photoLibrary: .shared()) {
                                    Text(R.string.localizable.portfolio_add_images_btt())
                                        .font(.headline)
                                        .foregroundColor(Color(R.color.gray6.name))
                                        .padding(8)
                                        .padding(.horizontal, 16)
                                        .background(Color(R.color.gray1.name))
                                        .cornerRadius(20)
                                }
                                
                            }
                        }
                    }
                }
            }
    }
    private func imageStyleAuthor(genre: String) -> String {
        switch genre {
        case "Aerial":
            return "paperplane.fill";
        case "Architecture":
            return "building.2.fill";
        case "Documentary":
            return "film";
        case "Event":
            return "balloon.2.fill";
        case "Fashion":
            return "mouth";
        case "Food":
            return "cup.and.saucer.fill";
        case "Love Story":
            return "heart.fill";
        case "Macro":
            return "camera.macro";
        case "People":
            return "person.fill";
        case "Pet":
            return "pawprint.fill";
        case "Portraits":
            return "person.crop.circle.fill";
        case "Product":
            return "car.fill";
        case "Real Estate":
            return "house.fill";
        case "Sports":
            return "figure.run";
        case "Wedding":
            return "heart";
        case "Wildlife":
            return "hare.fill";
        default:
            return "camera"
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    
    static var previews: some View {
        NavigationStack{
            PortfolioView(with: viewModel, path: .constant(NavigationPath()))
        }
    }
}

private class MockViewModel: PortfolioViewModelType, ObservableObject {
    var portfolioIsShow: Bool = true
    var avatarImage: UIImage? = nil
    func getAvatarImage(imagePath: String) async throws {}
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
    var selectAvatar: PhotosPickerItem?
    var avatarAuthorID = UUID()
    
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
