//
//  PortfolioEditView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/20/23.
//

import SwiftUI
import PhotosUI

struct PortfolioEditView<ViewModel: PortfolioEditViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var isTapped = false
    @State private var showStyleList: Bool = false
    @State private var showScheduleView: Bool = false
    @State private var isAvatarUploadInProgress = false
    @State private var loadingImage = false
    @State private var locationAuthor = ""
    @State private var selectedAvatar: PhotosPickerItem?
    
    init(with viewModel : ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                VStack(spacing: 24){
                    avatarImageSection
                    textField(fieldName: R.string.localizable.portfolio_first_name(), propertyName: $viewModel.nameAuthor)
                    
                    textField(fieldName: R.string.localizable.portfolio_last_name(), propertyName: $viewModel.familynameAuthor)
                    
                    textField(fieldName: R.string.localizable.portfolio_age(), propertyName: $viewModel.ageAuthor)
                    sexSection
                    locationSection
                    photoStyleSection
                        .onTapGesture {
                            showStyleList.toggle()
                        }
                        .sheet(isPresented: $showStyleList) {
                            PhotographyStylesView(styleSelected: $viewModel.styleAuthor)
                        }
                    
                    descriptionSection
                    addSchedule
                        .onTapGesture {
                            showScheduleView.toggle()
                        }
                }
                .sheet(isPresented: $showScheduleView) {
                    PortfolioScheduleView(with: PortfolioScheduleViewModel(), showScheduleView: $showScheduleView)
                        .onAppear { UIDatePicker.appearance().minuteInterval = 30 }

                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(R.string.localizable.save()) {
                            Task {
                                try await viewModel.setAuthorPortfolio(portfolio:
                                DBPortfolioModel(id: UUID().uuidString,
                                                 author: DBAuthor(rateAuthor: 0.0,
                                                                  likedAuthor: true,
                                                                  typeAuthor: viewModel.typeAuthor,
                                                                  nameAuthor: viewModel.nameAuthor,
                                                                  familynameAuthor: viewModel.familynameAuthor,
                                                                  sexAuthor: viewModel.sexAuthor,
                                                                  ageAuthor: viewModel.ageAuthor,
                                                                  location: locationAuthor,
                                                                  latitude: viewModel.latitude,
                                                                  longitude: viewModel.longitude,
                                                                  regionAuthor: viewModel.regionAuthor,
                                                                  styleAuthor: viewModel.styleAuthor,
                                                                  imagesCover: []),
                                                 avatarAuthor: viewModel.avatarAuthor,
                                                 smallImagesPortfolio: [],
                                                 largeImagesPortfolio: [],
                                                 descriptionAuthor: viewModel.descriptionAuthor,
                                                 schedule: [DbSchedule](),
                                                 bookingDays: []
                                                ))
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .foregroundColor(Color(R.color.gray2.name))
                        .padding()
                    }
                }
                .padding(.bottom, 64)
                .onAppear{
                    locationAuthor = viewModel.locationAuthor
                }
            }
        }
    }
    
    private var avatarImageSection: some View {
        PhotosPicker(selection: $selectedAvatar,
                     matching: .any(of: [.images, .not(.videos)]),
                     preferredItemEncoding: .automatic,
                     photoLibrary: .shared()) {
            AsyncImage(url: URL(string: viewModel.avatarAuthor)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Color.gray.opacity(0.2)
                }
            }
            .mask {
                Circle()
            }
            .frame(width: 110, height: 110)
            .id(viewModel.avatarAuthorID)
        }
         .onChange(of: selectedAvatar, perform: { avatar in
             guard !isAvatarUploadInProgress else {
                 return
             }
             isAvatarUploadInProgress = true
             Task {
                 do {
                     withAnimation {
                         loadingImage = true
                     }
                     try await viewModel.addAvatar(selectImage: avatar)
                     viewModel.avatarAuthorID = UUID()
                     loadingImage = false
                 } catch {
                     print("Error uploading avatar: \(error)")
                 }
                 
                 isAvatarUploadInProgress = false
             }
         })
         .overlay{
             // Show a ProgressView while waiting for the photo to load
             if loadingImage {
                 ProgressView()
                     .progressViewStyle(CircularProgressViewStyle())
                     .frame(width: 110, height: 110)
                 
                     .background(Color.white.opacity(0.7))
                     .clipShape(Circle())
                     .animation(.default, value: loadingImage)
             }
         }
    }
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            textField(fieldName: R.string.localizable.portfolio_location(), propertyName: $locationAuthor)
            
            ForEach(viewModel.locationResult) { result in
                if locationAuthor != result.location {
                    VStack(alignment: .leading){
                        Text(result.city)
                            .font(.subheadline)
                            .foregroundColor(Color(R.color.gray2.name))
                            .padding(.leading, 32)
                        Text(result.location)
                            .font(.footnote)
                            .foregroundColor(Color(R.color.gray4.name))
                            .padding(.leading, 32)
                        Divider()
                            .padding(.horizontal, 32)
                    }
                    .onTapGesture {
                        print("before \(locationAuthor)")
                        
                        self.locationAuthor = result.location
                        viewModel.latitude = result.latitude
                        viewModel.longitude = result.longitude
                        
                        viewModel.regionAuthor = result.regionCode
                        print("after \(locationAuthor)")
                        print("result.location \(result.location)")
                        
                    }
                }
            }
            .onChange(of: locationAuthor, perform: { newLocation in
                viewModel.searchLocation(text: newLocation )
                print("location Result on view: \(viewModel.locationResult)")
                
            })
        }
        .padding(.horizontal)
    }
    private var sexSection: some View {
        HStack{
            Text(R.string.localizable.portfolio_gender())
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
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
            
            TextEditor(text: $viewModel.descriptionAuthor)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
                .padding(.horizontal)
                .frame(height: 165)
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1))
        }.padding(.horizontal)
    }
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
    private func textField(fieldName: String, propertyName: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4){
            Text(fieldName)
                .font(.caption)
                .foregroundColor(Color(R.color.gray4.name))
                .padding(.horizontal)
            
            TextEditor(text: propertyName)
                .font(.callout)
                .foregroundColor(Color(R.color.gray2.name))
                .padding(.horizontal)
                .frame(height: 36)
                .padding(.vertical, 2)
                .overlay{
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(R.color.gray5.name), lineWidth: 1)}
        }
    }

}

struct PortfolioEditView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    
    static var previews: some View {
        PortfolioEditView(with: PortfolioEditViewModel(
            locationAuthor: viewModel.locationAuthor,
            typeAuthor: .constant(viewModel.typeAuthor),
            nameAuthor: .constant(viewModel.nameAuthor),
            avatarAuthorID: .constant(UUID()),
            avatarURL: .constant(viewModel.avatarURL),
            familynameAuthor: .constant(viewModel.familynameAuthor),
            sexAuthor: .constant("Select"),
            ageAuthor: .constant(viewModel.ageAuthor),
            styleAuthor: .constant(viewModel.styleAuthor),
            avatarAuthor: .constant(viewModel.avatarAuthor),
            descriptionAuthor: .constant(viewModel.descriptionAuthor),
            longitude: .constant(0.0),
            latitude: .constant(0.0),
            regionAuthor: .constant("TH")))
    }
}

private class MockViewModel: ObservableObject, PortfolioEditViewModelType {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var regionAuthor: String = ""
    var avatarAuthorID: UUID = UUID()
    var avatarImageID: UUID = UUID()
    var selectedAvatar: PhotosPickerItem?
    var avatarURL: URL?
    func avatarPathToURL(path: String) async throws -> URL {
        URL(string: "")!
    }
    var typeAuthor = "photo"
    func addAvatar(selectImage: PhotosPickerItem?) async throws {}
    var sexAuthorList: [String] = ["Select", "Male", "Female"]
    var dbModel: DBPortfolioModel?
    var styleOfPhotography: [String] = ["Aerial", "Architecture", "Documentary", "Event", "Fashion", "Food", "Love Story", "Macro", "People", "Pet", "Portraits", "Product", "Real Estate", "Sports", "Wedding", "Wildlife"]    
    var locationAuthor: String = "Hamburg"
    var locationResult: [DBLocationModel] = []
    var avatarAuthor: String = "https://images.unsplash.com/photo-1558612937-4ecf7ae1e375?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHBvcnRyZXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"
    var nameAuthor: String = ""
    var familynameAuthor: String = ""
    var ageAuthor: String = ""
    var sexAuthor: String = ""
    var location: String = "Hamburg"
    var styleAuthor: [String]  = []
    var descriptionAuthor: String  = ""
    func updatePreview() {}
    func getAuthorPortfolio() async throws {}
    func setAuthorPortfolio(portfolio: DBPortfolioModel) async throws {}
    func searchLocation(text: String){}
}
