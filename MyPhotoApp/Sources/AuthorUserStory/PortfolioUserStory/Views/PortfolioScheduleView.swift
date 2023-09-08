//
//  PortfolioScheduleView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/3/23.
//

import SwiftUI

struct PortfolioScheduleView: View {
    @State var startDate: Date
    @State var endDate: Date
    @State var timeIntervalSelected: String
    @State var holidays: Bool
    @State var price: String
    @State var schedules: [Schedule] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(schedules.indices, id: \.self) { index in
                    AddScheduleSection(
                        schedule: $schedules[index],
                        onDelete: { schedules.remove(at: index) }
                    )
                }
                Button(action: {
                    // Add a new schedule when the button is tapped
                    schedules.append(Schedule())
                }) {
                    Text(R.string.localizable.schedule_add())
                        .foregroundColor(Color(R.color.gray1.name))

                }
            }.navigationTitle(R.string.localizable.schedule())
        }
    }
}
struct AddScheduleSection: View {
    @Binding var schedule: Schedule
    var onDelete: () -> Void
    var interval: [String] = ["1/2", "1", "2", "3", "6", "8", "12"]

    var body: some View {
        Section {
            Toggle(R.string.localizable.schedule_holidays(), isOn: $schedule.holidays)
                .foregroundColor(Color(R.color.gray3.name))
                .tint(Color(R.color.gray1.name))
            DatePicker(R.string.localizable.schedule_start(), selection: $schedule.startDate)
                .foregroundColor(Color(R.color.gray3.name))
            DatePicker(R.string.localizable.schedule_end(), selection: $schedule.endDate)
                .foregroundColor(Color(R.color.gray3.name))
            Picker(R.string.localizable.schedule_interval(), selection: $schedule.timeIntervalSelected) {
                ForEach(interval, id: \.self) { item in
                    Text(item)
                }
            }
            .pickerStyle(.menu)
            .foregroundColor(Color(R.color.gray3.name))
            .accentColor(.black)
            
            HStack {
                Text(R.string.localizable.schedule_price())
                    .foregroundColor(Color(R.color.gray3.name))
                TextField(R.string.localizable.schedule_price_per_slot(), text: $schedule.price)
                    .keyboardType(.decimalPad)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.trailing)
            }
            
            Button(action: {
                onDelete()
            }) {
                Text(R.string.localizable.schedule_delete())
                    .foregroundColor(.red)
            }
        }
    }
}
struct Schedule {
    var holidays: Bool = false
    var startDate: Date = Date()
    var endDate: Date = Date()
    var timeIntervalSelected: String = "1"
    var price: String = ""
}

struct PortfolioScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioScheduleView(startDate: Date(), endDate: Date(), timeIntervalSelected: "1", holidays: true, price: "")
    }
}
