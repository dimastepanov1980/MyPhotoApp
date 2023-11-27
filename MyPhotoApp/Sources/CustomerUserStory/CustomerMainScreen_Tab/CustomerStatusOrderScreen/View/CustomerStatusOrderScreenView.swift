//
//  CustomerStatusOrderScreenView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 11/22/23.
//

import SwiftUI

struct CustomerStatusOrderScreenView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () async throws -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(R.color.gray1.name))
            
            Text(message)
                .font(.callout)
                .foregroundColor(Color(R.color.gray3.name))
            
            Button {
                Task {
                    do {
                        try await action()
                    } catch {
                        // Handle error if needed
                        print("Error: \(error)")
                    }
                }
            } label: {
                        Text(buttonTitle)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(R.color.gray6.name))
                            .padding(12)
                            .padding(.horizontal, 36)
                            .background(Color(R.color.gray1.name))
                            .cornerRadius(36)
            }
            .padding(.top, 36)

        }
        .multilineTextAlignment(.center)
    }
}

struct CustomerStatusOrderScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerStatusOrderScreenView(title: "Hello", message: "Welcome", buttonTitle: "Best Idea", action: {//
            
        })
    }
}
