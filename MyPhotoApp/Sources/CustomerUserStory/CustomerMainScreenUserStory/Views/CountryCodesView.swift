//
//  CountryCodesView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/23/23.
//

import SwiftUI

struct CountryCodesView: View {
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

func countryFlag(_ countryCode: String) -> String {
  String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap {
    UnicodeScalar(127397 + $0.value)
  }))
}

struct CountryCodesView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodesView()
    }
}
