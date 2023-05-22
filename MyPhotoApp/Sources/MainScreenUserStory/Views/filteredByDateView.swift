//
//  SwiftUIView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 5/22/23.
//

import SwiftUI

struct Item: Identifiable {
    let id: UUID
    let name: String
    let date: Date
}

struct FilteredItemsView: View {
    let filteredItems: [Item]

    var body: some View {
        ForEach(filteredItems) { item in
            Text(item.name)
        }
    }
}

struct ContentView: View {
    let filterDate: Date
    let items: [Item]

    var body: some View {
        VStack {
            Text("Filtered Items:")
                .font(.title)
                .padding()

            FilteredItemsView(filteredItems: items.filter { item in
                Calendar.current.isDate(item.date, inSameDayAs: filterDate)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            Item(id: UUID(), name: "Item 1", date: Date()),
            Item(id: UUID(), name: "Item 2", date: Calendar.current.date(byAdding: .day, value: +1, to: Date()) ?? Date()),
            Item(id: UUID(), name: "Item 3", date: Calendar.current.date(byAdding: .day, value: +2, to: Date()) ?? Date()),
            Item(id: UUID(), name: "Item 4", date:  Date()),
            Item(id: UUID(), name: "Item 5", date: Calendar.current.date(byAdding: .day, value: +4, to: Date()) ?? Date())
        ]

        ContentView(filterDate: Date(), items: items)
    }
}
