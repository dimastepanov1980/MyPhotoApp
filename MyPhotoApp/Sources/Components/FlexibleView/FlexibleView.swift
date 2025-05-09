//
//  FlexibleView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 8/27/23.
//

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
  let data: Data
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content
  // The initial width should not be `0`, otherwise all items will be layouted in one row,
  // and the actual layout width may exceed the value we desired.
  @State private var availableWidth: CGFloat = 10

  var body: some View {
    ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
      Color.clear
        .frame(height: 1)
        .readSize { size in
          availableWidth = size.width
        }

      _FlexibleView(
        availableWidth: availableWidth,
        data: data,
        spacing: spacing,
        alignment: alignment,
        content: content
      )
    }
  }
}
