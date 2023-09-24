//
//  SearchCustomerMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/22/23.
//

import SwiftUI

struct SearchCustomerMainScreenView: View {
    var filterspace: Namespace.ID
    @Binding var filterShow: Bool
    
    @State var show: Bool = true

    @Binding var searchLocation: String
    @Binding var locationAuthor: String
    @Binding var locationResult: [DBLocationModel]
    @Binding var chooseDate: Date
    @Binding var onlyFemale: Bool

    var body: some View {
        ZStack{
            if show {
                ScrollView {
                    VStack(spacing: 30) {
                        searchSection
                            .matchedGeometryEffect(id: "search", in: filterspace)
                        Spacer()

                    }
                    .overlay{
                        VStack{
                            Spacer()
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: "overlay", in: filterspace)
                    .background(Color.white)
                    .frame (height: 20)
                  
                
                }
                
                

            } else {
                    VStack {
                        
                        Spacer()

                    }.frame(maxWidth: .infinity)
                    .overlay{
                        VStack(spacing: 20){
                            searchSection
                                .matchedGeometryEffect(id: "search", in: filterspace)
                            dateSection
                            onlyFemaleSection
                            Spacer()
                            CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                                // Add getPhotographer
                            }
                        }
                    }
                    .padding(.top)
                    .matchedGeometryEffect(id: "overlay", in: filterspace)
                    .padding(.horizontal)
                    .background(Color.white)
                
                }
            
        }.onTapGesture {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                show.toggle()
            }
        }
    }
    
    private var locationRsult: some View {
        ScrollView{
            VStack{
                ForEach(locationResult) { result in
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
                        
                        /*.onTapGesture {
                            withAnimation {
                                viewModel.locationAuthor = result.location
                                viewModel.latitude = result.latitude
                                viewModel.longitude = result.longitude
                                viewModel.regionAuthor = result.regionCode
                                Task {
                                    do {
                                        let dbPortfolio = try await viewModel.getPortfolio(longitude: result.longitude, latitude:  result.latitude)
                                        viewModel.portfolio = dbPortfolio.map { AuthorPortfolioModel(portfolio: $0) }
                                        print(result.longitude, result.latitude)
                                        print(viewModel.portfolio)
                                    } catch {
                                        print(String(describing: error))
                                    }
                                }
                            }
                        }*/
                    }
                }
            }
            .background(Color.white)
        }
     }
    private var searchSection: some View {
        VStack {
            CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: $searchLocation)
        }
        .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)


     }
    private var dateSection: some View {
        VStack {
            DatePicker("Chose Date", selection: $chooseDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
        }
            .background(Color.white)
            .cornerRadius(20, corners: .allCorners)
            .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)

     }
    private var onlyFemaleSection: some View {
            Toggle(isOn: $onlyFemale) {
                HStack {
                    Image(R.image.ic_female.name)
                        .foregroundColor(Color(R.color.gray3.name))

                    Text(R.string.localizable.gender_specify_gender())
                        .font(.callout)
                        .foregroundColor(Color(R.color.gray4.name))
                }.padding(.leading)
            }
            .tint(Color(R.color.gray2.name))
        .padding(8)
        .background(Color.white)
        .cornerRadius(20, corners: .allCorners)
        .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.05), lineWidth: 1)
        )

    }
}

struct SearchCustomerMainScreenView_Previews: PreviewProvider {
    @Namespace static var filterspace
    static var previews: some View {
        SearchCustomerMainScreenView(filterspace: filterspace, filterShow: .constant(true), searchLocation: .constant(""), locationAuthor: .constant(""), locationResult: .constant([]), chooseDate: .constant(Date()), onlyFemale: .constant(false))
    }
}
