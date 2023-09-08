//
//  PortfolioView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/20/23.
//

import SwiftUI

struct PortfolioView<ViewModel: PortfolioViewModelType> : View {
    
    @ObservedObject var viewModel: ViewModel
    @State var isTapped = false
    @State var showStyleList: Bool = false
    @State var showScheduleView: Bool = false

    init(with viewModel : ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                VStack(spacing: 24){
                    avatarImage
                    CustomTextField(nameTextField: R.string.localizable.portfolio_first_name(), text: $viewModel.nameAuthor)
                    CustomTextField(nameTextField: R.string.localizable.portfolio_last_name(), text: $viewModel.familynameAuthor)
                    CustomTextField(nameTextField: R.string.localizable.portfolio_age(), text: $viewModel.ageAuthor)
                    genderSection
                    searchLocation
                    photoStyleSection
                        .onTapGesture {
                            showStyleList.toggle()
                        }
                        .navigationDestination(isPresented: $showStyleList) {
                            PhotoGenresView(photographyStyles: viewModel.styleOfPhotography, styleSelected: $viewModel.styleAuthor, showStyleList: $showStyleList)
                        }
                    
                    descriptionSection
                    addSchedule
                        .onTapGesture {
                            showScheduleView.toggle()
                        }
                }
                .navigationDestination(isPresented: $showScheduleView) {
                    PortfolioScheduleView(startDate: Date(), endDate: Date(), timeIntervalSelected: "1/2", holidays: false, price: "0.0")
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(R.string.localizable.save()) {
                                Task {
                                    try await viewModel.setAuthorPortfolio(portfolio: DBPortfolioModel(id: UUID().uuidString,
                                                                           author: DBAuthor(id: UUID().uuidString,
                                                                                            rateAuthor: 0.0,
                                                                                            likedAuthor: true,
                                                                                            nameAuthor: viewModel.nameAuthor,
                                                                                            familynameAuthor: viewModel.familynameAuthor,
                                                                                            sexAuthor: viewModel.sexAuthor,
                                                                                            ageAuthor: viewModel.ageAuthor,
                                                                                            location: viewModel.locationAuthor,
                                                                                            styleAuthor: viewModel.styleAuthor,
                                                                                            imagesCover: [],
                                                                                            priceAuthor: ""),
                                                                           avatarAuthor: nil,
                                                                           smallImagesPortfolio: [],
                                                                           largeImagesPortfolio: [],
                                                                           descriptionAuthor: viewModel.descriptionAuthor,
                                                                           reviews: [DBReviews](),
                                                                           appointmen: [DBAppointmen]()))
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
    var avatarImage: some View {
        VStack {
            AsyncImage(url: stringToURL(imageString: viewModel.avatarAuthor)){ image in
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
            .frame(width: 110, height: 110)
        }
    }
    var genderSection: some View {
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
    var descriptionSection: some View {
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

        }.padding(.horizontal)    }
    var photoStyleSection: some View {
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
    var addSchedule: some View {
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
    var searchLocation: some View {
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
    
    func selectGender(gender: String?) -> String {
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

struct PortfolioView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()
    
    static var previews: some View {
        PortfolioView(with: viewModel)
    }
}

private class MockViewModel: PortfolioViewModelType, ObservableObject {
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
