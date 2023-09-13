//
//  PortfolioEditView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/20/23.
//

import SwiftUI
import PhotosUI

struct PortfolioEditView<ViewModel: PortfolioViewModelType> : View {
    
    @ObservedObject var viewModel: ViewModel
    @State var isTapped = false
    @State var showStyleList: Bool = false
    @State var showScheduleView: Bool = false
    @State private var avatarImageID = UUID()
    @State private var isAvatarUploadInProgress = false
    
    
    @Binding var selectedAvatar: PhotosPickerItem?
    @Binding var nameAuthor: String
    @Binding var avatarURL: URL?
    @Binding var familynameAuthor: String
    @Binding var ageAuthor: String
    @Binding var locationAuthor: String
    @Binding var styleAuthor: [String]
    @Binding var avatarAuthor: String
    @Binding var descriptionAuthor: String
    
    init(with viewModel : ViewModel,
         selectedAvatar: Binding<PhotosPickerItem?>,
         nameAuthor: Binding<String>,
         avatarURL: Binding<URL?>,
         familynameAuthor: Binding<String>,
         ageAuthor: Binding<String>,
         locationAuthor: Binding<String>,
         styleAuthor: Binding<[String]>,
         avatarAuthor: Binding<String>,
         descriptionAuthor: Binding<String>
    ) {
        self.viewModel = viewModel
        self._nameAuthor = nameAuthor
        self._avatarURL = avatarURL
        self._selectedAvatar = selectedAvatar
        self._familynameAuthor = familynameAuthor
        self._ageAuthor = ageAuthor
        self._locationAuthor = locationAuthor
        self._styleAuthor = styleAuthor
        self._avatarAuthor = avatarAuthor
        self._descriptionAuthor = descriptionAuthor
    }
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                VStack(spacing: 24){
                    avatarImageSection
                    CustomTextField(nameTextField: R.string.localizable.portfolio_first_name(), text: $nameAuthor)
                    CustomTextField(nameTextField: R.string.localizable.portfolio_last_name(), text: $familynameAuthor)
                    CustomTextField(nameTextField: R.string.localizable.portfolio_age(), text: $ageAuthor)
                    sexSection
                    locationSection
                    photoStyleSection
                        .onTapGesture {
                            showStyleList.toggle()
                        }
                        .navigationDestination(isPresented: $showStyleList) {
                            PhotographyStylesView(photographyStyles: viewModel.styleOfPhotography, styleSelected: $viewModel.styleAuthor, showStyleList: $showStyleList)
                        }
                    
                    descriptionSection
                    addSchedule
                        .onTapGesture {
                            showScheduleView.toggle()
                        }
                }
                .navigationDestination(isPresented: $showScheduleView) {
                    PortfolioScheduleView(with: PortfolioScheduleViewModel())
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(R.string.localizable.save()) {
                                Task {
                                    try await viewModel.setAuthorPortfolio(portfolio: DBPortfolioModel(id: UUID().uuidString,
                                                                           author: DBAuthor(id: UUID().uuidString,
                                                                                            rateAuthor: 0.0,
                                                                                            likedAuthor: true,
                                                                                            nameAuthor: nameAuthor,
                                                                                            familynameAuthor: familynameAuthor,
                                                                                            sexAuthor: viewModel.sexAuthor,
                                                                                            ageAuthor: ageAuthor,
                                                                                            location:  viewModel.locationAuthor,
                                                                                            styleAuthor: styleAuthor,
                                                                                            imagesCover: [],
                                                                                            priceAuthor: ""),
                                                                           avatarAuthor: avatarAuthor,
                                                                           smallImagesPortfolio: [],
                                                                           largeImagesPortfolio: [],
                                                                           descriptionAuthor: descriptionAuthor,
                                                                           reviews: [DBReviews](),
                                                                           schedule: [DbSchedule](),
                                                                           bookingDays: nil))
                                }
                        }
                        .foregroundColor(Color(R.color.gray2.name))
                        .padding()
                                        }
                }
                .padding(.bottom, 64)
            }
        }
    }
    private var avatarImageSection: some View {
        PhotosPicker(selection: $viewModel.selectedAvatar,
                     matching: .any(of: [.images, .not(.videos)]),
                     preferredItemEncoding: .automatic,
                     photoLibrary: .shared()) {
            AsyncImage(url: viewModel.avatarURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    
            } placeholder: {
                ZStack{
                    ProgressView()
                    Color.gray.opacity(0.2)
                }
            }
            .mask {
                Circle()
            }
            .frame(width: 110, height: 110)
            .id(viewModel.avatarImageID) // Use this ID to trigger a refresh when needed
        }
                     .onChange(of: viewModel.selectedAvatar, perform: { avatar in
                         // Check if an avatar upload is already in progress
                         guard !isAvatarUploadInProgress else {
                             return
                         }
                         
                         isAvatarUploadInProgress = true
                         
                         Task {
                             print(viewModel.avatarImageID.uuidString)
                             do {
                                 try await viewModel.addAvatar(selectImage: avatar)
                                 
                                 // After the Task is completed, trigger a refresh of the AsyncImage
                                 self.viewModel.avatarImageID = UUID()
                                 print(viewModel.avatarImageID.uuidString)
                                 
                             } catch {
                                 // Handle any errors that may occur during avatar upload
                                 print("Error uploading avatar: \(error)")
                             }
                             
                             isAvatarUploadInProgress = false
                         }
                     })
    }
    private var locationSection: some View {
        VStack(alignment: .leading) {
            CustomTextField(nameTextField: R.string.localizable.portfolio_location(), text: $viewModel.locationAuthor)
            ForEach(viewModel.locationResult) { result in
                if viewModel.locationAuthor != result.location {
                    VStack(alignment: .leading) {
                        Text(result.location)
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray4.name))
                            .padding(.leading, 36)
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.locationAuthor = result.location
                        }
                    }
                }
            }
        }
    }

    private var sexSection: some View {
        HStack{
            Text(R.string.localizable.portfolio_gender())
                .font(.callout)
                .foregroundColor(Color(R.color.gray4.name))
            Spacer()
            Picker(R.string.localizable.portfolio_genre(), selection: $viewModel.sexAuthor) {
                ForEach(viewModel.sexAuthorList, id: \.self) {
                    Text(selectGender(gender: $0))
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal)
        .frame(height: 42)
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(R.color.gray5.name), lineWidth: 1))
        .padding(.horizontal)
    }
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(R.string.localizable.portfolio_about())
                .font(.caption)
                .foregroundColor(Color(R.color.gray4.name))
                .padding(.horizontal)
            
            TextEditor(text: $descriptionAuthor)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
                .padding(.horizontal)
                .frame(height: 165)
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1))

        }.padding(.horizontal)    }
    private var photoStyleSection: some View {
        HStack{
            Text(viewModel.styleAuthor.joined(separator: ", "))
                .font(.callout)
                .foregroundColor(viewModel.styleAuthor.joined().isEmpty ? Color(R.color.gray4.name) : Color(R.color.gray2.name))
                .frame(height: 42)
                .padding(.horizontal)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.callout)
                .foregroundColor(viewModel.styleAuthor.joined().isEmpty ? Color(R.color.gray4.name) : Color(R.color.gray2.name))
                .frame(height: 42)
                .padding(.horizontal)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(R.color.gray5.name), lineWidth: 1))
        .overlay(content: {
            HStack {
                Text(R.string.localizable.portfolio_genre())
                    .font(.callout)
                    .scaleEffect(isTapped || !viewModel.styleAuthor.joined().isEmpty ? 0.7 : 1)
                    .offset(y: isTapped || !viewModel.styleAuthor.joined().isEmpty ? -30 : 0 )
                    .foregroundColor(Color(R.color.gray4.name))
                    .padding(.leading, viewModel.styleAuthor.joined().isEmpty ? 20 : -5)
                Spacer()
            }
        })
        .padding(.horizontal)
    }
    private var addSchedule: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color(R.color.gray1.name))
            
            HStack{
                Text(R.string.localizable.schedule_set())
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray6.name))
                    .padding(.leading, 24)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.callout)
                    .foregroundColor(Color(R.color.gray6.name))
                    .frame(height: 42)
                    .padding(.trailing, 24)
            }
        }
        
        .padding(.horizontal)
    }
    private func selectGender(gender: String?) -> String {
        if let select = gender {
            switch select {
            case "Select":
                return R.string.localizable.gender_select()
            case "Male":
                return R.string.localizable.gender_male()
            case "Female":
                return R.string.localizable.gender_female()
            default:
                break
            }
        }
        return ""
    }

}

struct PortfolioEditView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    
    static var previews: some View {
        PortfolioEditView(with: viewModel, selectedAvatar: .constant(viewModel.selectedAvatar),
                          nameAuthor: .constant(viewModel.nameAuthor),
                          avatarURL: .constant(viewModel.avatarURL),
                          familynameAuthor: .constant(viewModel.familynameAuthor),
                          ageAuthor: .constant(viewModel.ageAuthor),
                          locationAuthor: .constant(viewModel.locationAuthor),
                          styleAuthor: .constant(viewModel.styleAuthor),
                          avatarAuthor: .constant(viewModel.avatarAuthor),
                          descriptionAuthor: .constant(viewModel.descriptionAuthor))
    }
}

private class MockViewModel: PortfolioViewModelType, ObservableObject {
    var avatarImageID: UUID = UUID()
    var selectedAvatar: PhotosPickerItem?
    var avatarURL: URL?
    func avatarPathToURL(path: String) async throws -> URL {
        URL(string: "")!
    }
    
    func addAvatar(selectImage: PhotosPickerItem?) async throws {}
    var sexAuthorList: [String] = ["Select", "Male", "Female"]
    var dbModel: DBPortfolioModel?
    var styleOfPhotography: [String] = ["Aerial", "Architecture", "Documentary", "Event", "Fashion", "Food", "Love Story", "Macro", "People", "Pet", "Portraits", "Product", "Real Estate", "Sports", "Wedding", "Wildlife"]    
    var locationAuthor: String = ""
    var locationResult: [DBLocationModel] = []
    var avatarAuthor: String = "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"
    var nameAuthor: String = ""
    var familynameAuthor: String = ""
    var ageAuthor: String = ""
    var sexAuthor: String = ""
    var location: String = ""
    var styleAuthor: [String]  = []
    var descriptionAuthor: String  = ""
    func updatePreview() {}
    func getAuthorPortfolio() async throws {}
    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws {}

}
