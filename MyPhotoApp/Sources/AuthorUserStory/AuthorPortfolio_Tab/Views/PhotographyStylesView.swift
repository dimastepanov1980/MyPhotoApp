//
//  PhotographyStylesView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/2/23.
//

import SwiftUI

struct PhotographyStylesView: View {
    @State var styleOfPhotography =  ["Aerial", "Architecture", "Documentary", "Event", "Fashion", "Food",
                                      "Love Story", "Macro", "People", "Pet", "Portraits", "Product", "Real Estate",
                                      "Sports", "Wedding", "Wildlife"]
    @Binding var styleSelected: [String]
//    @Binding var showStyleList: Bool

    init(/*photographyStyles: [String],*/styleSelected: Binding<[String]>/*, showStyleList: Binding<Bool>*/) {
//        self.photographyStyles = photographyStyles
        self._styleSelected = styleSelected
//        self._showStyleList = showStyleList
    }
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(self.styleOfPhotography, id: \.self) { item in
                    MultipleSelectionRow(title: item, isSelected: self.styleSelected.contains(item)) {
                        if self.styleSelected.contains(item) {
                            self.styleSelected.removeAll(where: { $0 == item })
                        } else {
                            if self.styleSelected.count <= 3 {
                                self.styleSelected.append(item)
                            }
                        }
                    }
                }
            }
            .navigationTitle(R.string.localizable.portfolio_genre_description())
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            .scrollContentBackground(.hidden)
            .padding(.trailing)
        }
    }
    
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(photographyStyles(style: title))
                    .font(.subheadline)
                    .foregroundColor(Color(R.color.gray2.name))
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.subheadline)
                        .foregroundColor(Color(R.color.gray1.name))
                        .padding(.trailing, 6)
                }
            }
        }
    }
    
    func photographyStyles(style: String?) -> String {
        if let style = style {
            switch style {
            case "Aerial":
                return R.string.localizable.style_photography_aerial()
            case "Architecture":
                return R.string.localizable.style_photography_architecture()
            case "Documentary":
                return R.string.localizable.style_photography_documentary()
            case "Event":
                return R.string.localizable.style_photography_event()
            case "Fashion":
                return R.string.localizable.style_photography_fashion()
            case "Food":
                return R.string.localizable.style_photography_food()
            case "Love Story":
                return R.string.localizable.style_photography_loveStory()
            case "Macro":
                return R.string.localizable.style_photography_macro()
            case "People":
                return R.string.localizable.style_photography_people()
            case "Pet":
                return R.string.localizable.style_photography_pet()
            case "Portraits":
                return R.string.localizable.style_photography_portraits()
            case "Product":
                return R.string.localizable.style_photography_product()
            case "Real Estate":
                return R.string.localizable.style_photography_realEstate()
            case "Sports":
                return R.string.localizable.style_photography_sports()
            case "Wedding":
                return R.string.localizable.style_photography_wedding()
            case "Wildlife":
                return R.string.localizable.style_photography_wildlife()
            default:
                break
            }
        }
        return ""
    }
}

struct PhotoGenresView_Previews: PreviewProvider {
    static var previews: some View {
        PhotographyStylesView(/*photographyStyles: ["Aerial", "Sports"],*/ styleSelected: .constant(["Sports", "Aerial"])/*, showStyleList: .constant(false)*/)
    }
}


