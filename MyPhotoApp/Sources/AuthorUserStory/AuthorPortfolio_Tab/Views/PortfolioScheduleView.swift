//
//  PortfolioScheduleView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/3/23.
//

import SwiftUI

struct PortfolioScheduleView<ViewModel: PortfolioScheduleViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var showScheduleView: Bool
    
    init(with viewModel : ViewModel,
         showScheduleView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showScheduleView = showScheduleView
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.schedules.indices, id: \.self) { index in
                    AddScheduleSection(
                        schedule: $viewModel.schedules[index],
                        onDelete: { viewModel.schedules.remove(at: index) }
                    )
                }
                Button(action: {
                    // Add a new schedule when the button is tapped
                    viewModel.schedules.append(Schedule(id: UUID(), holidays: false, startDate: Date(), endDate: Date(), timeIntervalSelected: "1", price: "", timeZone: TimeZone.current.identifier))
                }) {
                    Text(R.string.localizable.schedule_add())
                        .foregroundColor(Color(R.color.gray1.name))

                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(R.string.localizable.save()) {
                        Task {
                            try await viewModel.setSchedule(schedules: viewModel.schedules)
                            showScheduleView.toggle()
                        }
                    }
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding()
                }
            }
            .navigationTitle(R.string.localizable.schedule())
        }
    }
}

struct AddScheduleSection: View {
    @Binding var schedule: Schedule
    var onDelete: () -> Void
    var interval: [String] = ["30", "60", "120", "180", "360", "480", "720"]
    @State var selectDate: Date = Date()

    var body: some View {
        Section {
            Toggle(R.string.localizable.schedule_holidays(), isOn: $schedule.holidays)
                .foregroundColor(Color(R.color.gray3.name))
                .tint(Color(R.color.gray1.name))
            DatePicker(R.string.localizable.schedule_start(), selection: $schedule.startDate, displayedComponents: [.hourAndMinute, .date])
                .foregroundColor(Color(R.color.gray3.name))
            DatePicker(R.string.localizable.schedule_end(), selection: $schedule.endDate, displayedComponents: [.hourAndMinute, .date])
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

struct PortfolioScheduleView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()

    static var previews: some View {
        PortfolioScheduleView(with: viewModel, showScheduleView: .constant(false))
    }
}

private class MockViewModel: PortfolioScheduleViewModelType, ObservableObject {
  
    func getSchedule() async throws -> [DbSchedule] {return []}
    func setSchedule(schedules: [Schedule]) async throws {}
    var startDate: Date = Date()
    var endDate: Date  = Date()
    var timeIntervalSelected: String = "1"
    var holidays: Bool = true
    var price: String = "5500"
    var schedules: [Schedule] = []
}
