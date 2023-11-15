//
//  CustomerSearchScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/14/23.
//
/*
import SwiftUI

struct CustomerSearchScreenView<ViewModel:CustomerSearchScreenViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(with: ViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                searchSection
                dateSection
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            .background(Color.white)
            VStack {
                Spacer()
                CustomButtonXl(titleText: R.string.localizable.customer_search(), iconName: "magnifyingglass") {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
//                        Task {
//                            let dbPortfolio = try await viewModel.getPortfolio(longitude: viewModel.longitude, latitude: viewModel.latitude, date: selectDate)
//
//                            if !dbPortfolio.isEmpty{
//                                portfolio = dbPortfolio.map { $0 }
//                                //                                        print("chek new location inside Task \(viewModel.longitude); \(viewModel.latitude)")
//                                //                                        print("Print portfolio in Task \(viewModel.portfolio)")
//                            } else {
//                                showAlertRequest.toggle()
//                            }
//                        }
//                        serchPageShow.toggle()
//                        print("chek new location \(viewModel.longitude); \(viewModel.latitude)")
                        
                    }
                    
                }
                    .offset(y: -80)
            }
            ScrollView{
                VStack{
                    ForEach(viewModel.locationResult) { result in
                        if viewModel.locationAuthor != result.location {
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
//                                withAnimation {
//                                    self.viewModel.locationAuthor = result.location
//                                    selectLocation = result.location
//                                    self.viewModel.latitude = result.latitude
//                                    self.viewModel.longitude = result.longitude
//                                    self.viewModel.regionAuthor = result.regionCode
//                                }
                            }
                        }
                    }
                }
                .background(Color.white)
            }.offset(y: 60)
        }
    }
    private var searchSection: some View {
        VStack {
            CustomerSearchBar(nameTextField: R.string.localizable.customer_search_bar(), text: $viewModel.locationAuthor)
        }
        .shadow(color: Color(.sRGBLinear, white: 0.2, opacity: 0.05),radius: 5)


     }
    private var dateSection: some View {
        VStack {
            DatePicker("Chose Date", selection: $selectDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .onChange(of: selectDate) { newDate in
                self.viewModel.selectedDate = newDate
                print("Selected date changed to: \( self.viewModel.selectedDate)")
                 }
        }
            .background(Color.white)
            .cornerRadius(20, corners: .allCorners)
            .shadow(color: Color(.sRGBLinear, white: 0.3, opacity: 0.2),radius: 5)

     }
}

struct CustomerSearchScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        CustomerSearchScreenView(with: mockModel)
    }
}

private class MockViewModel: CustomerSearchScreenViewModelType, ObservableObject {
    
}
*/
