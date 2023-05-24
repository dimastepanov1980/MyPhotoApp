//
//  VCellMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

struct VCellMainScreenView: View {
    let items: MainOrderModel
    
    var body: some View {
        HStack(alignment: .bottom){
            VStack(alignment: .leading, spacing: 8) {
                Text(items.place)
                    .lineLimit(1)
                    .font(.title2.bold())
                    .foregroundColor(Color(R.color.gray1.name))
                
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                        .foregroundColor(Color(R.color.gray2.name))
                    
                    Text(Date().displayHours)
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray2.name))
                        .padding(.trailing)
                    
                    Image(systemName: "timer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                        .foregroundColor(Color(R.color.gray2.name))
                    
                    Text(String(items.duration))
                        .font(.footnote)
                        .foregroundColor(Color(R.color.gray2.name))
                }
                
                Image(R.image.image0.name)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                    .overlay(Circle().stroke(Color(R.color.gray6.name), lineWidth: 1).shadow(radius: 10))
                
            }
            Spacer()
            Text(items.name)
                .font(.subheadline)
                .foregroundColor(Color(R.color.gray3.name))
        }.padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(Color(R.color.gray5.name))
        .cornerRadius(25)
    }
}

struct VCellMainScreenView_Previews: PreviewProvider {
    private static let mockModel = MockViewModelVCell()

    static var previews: some View {
        VCellMainScreenView(items: mockModel.mocData)
    }
}

private class MockViewModelVCell: ObservableObject {
    let mocData: MainOrderModel =
    MainOrderModel(id: UUID(),
                   name: "Ira",
                   instagramLink: nil,
                   place: "Kata Noy Beach",
                   price: 5500,
                   date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date(),
                   duration: 1.5,
                   description: nil,
                   imageUrl: "")
}
