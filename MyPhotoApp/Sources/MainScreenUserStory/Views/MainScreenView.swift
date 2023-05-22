//
//  MainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/21/23.
//

import SwiftUI

struct MainScreenView<ViewModel: MainScreenViewModelType> : View {
    @ObservedObject var viewModel: ViewModel
    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            daySection
            Spacer()
        }
    }
    
    var daySection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(R.string.localizable.today())
                    .font(.subheadline.bold())
                    .foregroundColor(Color(R.color.gray3.name))
                
                HStack {
                    Text(Data().description)
                        .font(.title.bold())
                        .foregroundColor(Color(R.color.gray1.name))
                    Image(R.image.ic_weater.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                }
            }
            Spacer()
            
            Image(R.image.image0.name)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fit)
                .frame(width: 56)
                .overlay(Circle().stroke(Color.white,lineWidth: 2).shadow(radius: 10))
        }.padding(.horizontal, 32)
    }
    
}
    


struct MainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()

    static var previews: some View {
        MainScreenView(with: mockModel)
    }
}

private class MockViewModel: MainScreenViewModelType, ObservableObject {
    @Published var userId: String = ""
    @Published var name: String =  ""
    @Published var place: String?
    @Published var date: Date = Date()
    @Published var duration: Double = 0.0
    @Published var imageUrl: String = ""
    @Published var weaterId: String = ""
    
    func createOrder() {
        //
    }
    
    func formattedDate() -> String {
        return "04 September"
    }
    

}
