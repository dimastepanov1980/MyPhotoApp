//
//  SwiftUIView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

struct ContentsView: View {
    @State private var shouldScroll = false

    var body: some View {
        VStack {
            Button("Scroll to Bottom") {
                shouldScroll.toggle()
            }
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(0..<100) { index in
                            Text("Item \(index)")
                                .padding()
                                .id(index)
                        }
                    }
                }
                .onChange(of: shouldScroll) { newValue in
                    if newValue {
                        withAnimation {
                            scrollViewProxy.scrollTo(99, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct ContentsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentsView()
    }
}
