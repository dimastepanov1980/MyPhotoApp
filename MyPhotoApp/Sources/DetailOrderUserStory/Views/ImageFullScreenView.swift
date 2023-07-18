//
//  ImageFullScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 7/17/23.
//

import SwiftUI

struct ImageFullScreenView: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset = CGSize.zero
    private let minScale = 1.0
    private let maxScale = 3.0

    var image: UIImage
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                adjustScale(from: state)
            }
            .onEnded { state in
                withAnimation {
                    checkScaleAmmount()
                }
                lastScale = 1.0
            }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                offset.width = value.translation.width / lastScale
                offset.height = value.translation.height / lastScale
            }
            .onEnded { _ in
                withAnimation {
                    checkOffset()
                }
            }
    }

// MARK: - доработать зуум
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(magnification/*.simultaneously(with: drag) доработать зуум*/)
                .statusBar(hidden: true)
        }
    }
    
    func adjustScale (from state: MagnificationGesture.Value) {
        let delta = state / lastScale
        scale *= delta
        lastScale = state
    }
    
    func getMinScaleAmmount() -> CGFloat {
        return max(scale, minScale)
    }
    func getMaxScaleAmmount() -> CGFloat {
        return min(scale, maxScale)
    }
    
    func checkScaleAmmount() {
        scale = getMinScaleAmmount()
        scale = getMaxScaleAmmount()
    }
    
    func checkOffset() {
        let scaledWidth = image.size.width * lastScale
        let scaledHeight = image.size.height * lastScale
        
        let maxWidth = (UIScreen.main.bounds.width - scaledWidth) / 2
        let maxHeight = (UIScreen.main.bounds.height - scaledHeight) / 2
        
        offset.width = max(-maxWidth, min(offset.width, maxWidth))
        offset.height = max(-maxHeight, min(offset.height, maxHeight))
    }
}

//struct ImageFullScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageFullScreenView(image: <#UIImage#>)
//    }
//}
