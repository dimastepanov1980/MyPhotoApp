//
//  HCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

import SwiftUI

struct HCellMainScreenView: View {
    let items: MainOrderModel
//    private let place: String
//    private let duration: Double
//    private let time: Data
//
//    init(place: String, duration: Double, time: Data) {
//        self.place = place
//        self.duration = duration
//        self.time = time
//    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(items.place)
                    .font(.title2.bold())
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top) {
                            Image(R.image.ic_time.name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                            
                            Text(Date().displayDate)
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                        HStack(alignment: .top) {
                            Image(R.image.ic_duration.name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16)
                            
                            Text(String(items.duration))
                                .font(.footnote)
                                .foregroundColor(Color(R.color.gray3.name))
                        }
                    }
                    Spacer()
                    Image(R.image.image0.name)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36)
                        .overlay(Circle().stroke(Color.white,lineWidth: 1).shadow(radius: 10))
                        
                        
                }
            } .padding(.vertical, 12)
            .frame(width: 165)
            .padding(.horizontal, 16)
            .background(Color(R.color.gray5.name))
            .cornerRadius(25)

    }
}

extension Date {
    var displayDate: String {
        self.formatted(
            .dateTime
                .hour(.conversationalDefaultDigits(amPM: .omitted))
                .minute()
        )
    }
}

struct HCellMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModel()
    
    static var previews: some View {
        HCellMainScreenView(items: mockModel.mocData)
    }
}


private class MockViewModel: ObservableObject {
    let mocData: MainOrderModel =
    MainOrderModel(userId: "",
                   name: "",
                   place: "Kata Noy Beach",
                   date: Date(),
                   duration: 1.5,
                   imageUrl: "",
                   weaterId: "")
}
