//
//  CustomerMainScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/20/23.
//

import SwiftUI
func countryFlag(_ countryCode: String) -> String {
  String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap {
    UnicodeScalar(127397 + $0.value)
  }))
}

struct CustomerMainScreenView: View {
    var body: some View {
        List(NSLocale.isoCountryCodes, id: \.self) { countryCode in
          HStack {
            Text(countryFlag(countryCode))
            Text(Locale.current.localizedString(forRegionCode: countryCode) ?? "")
            Spacer()
            Text(countryCode)
          }
        }
    }
}

struct CustomerMainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerMainScreenView()
    }
}
