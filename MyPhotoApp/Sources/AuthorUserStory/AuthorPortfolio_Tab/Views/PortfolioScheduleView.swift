//
//  PortfolioScheduleView.swift
//  MyPhotoApp
//
//  Created by Dima Stepanov on 9/3/23.
//

import SwiftUI

struct PortfolioScheduleView<ViewModel: PortfolioScheduleViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var router: Router<Views>

    @State var showScheduleTips: Bool = false
    @State private var scheduleTimeTag: [String] = ["08:00", "09:00", "10:00", "16:00", "17:00", "18:00"]
    
    init(with viewModel : ViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
            List {
                ForEach(viewModel.schedules.indices, id: \.self) { index in
                    AddScheduleSection(
                        schedule: $viewModel.schedules[index],
                        onDelete: { viewModel.schedules.remove(at: index) }
                    )
                }
                Button(action: {
                    viewModel.schedules.append(Schedule(id: UUID(), holidays: false, startDate: Date(), endDate: Date(), timeIntervalSelected: "60", price: "", timeZone: TimeZone.current.identifier))
                }) {
                    HStack {
                        Text(R.string.localizable.schedule_add())
                            .foregroundColor(Color(R.color.gray1.name))
                            .font(.body.bold())
                        Spacer()
                        Button {
                            showScheduleTips = true
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.body)
                                .foregroundColor(Color(R.color.gray3.name))
                        }

                    }
                }
            }
   
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(R.string.localizable.save()) {
                        Task {
                            try await viewModel.setSchedule(schedules: viewModel.schedules)
                            router.pop()
                        }
                    }
                    .foregroundColor(Color(R.color.gray2.name))
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButtonView())
            .navigationTitle(R.string.localizable.schedule())
            .sheet(isPresented: $showScheduleTips) {
                scheduleTips
                    .presentationDetents([.fraction(0.8)])

            }
    }
    private var scheduleTips: some View {
        
        VStack(alignment: .leading, spacing: 16){
            Text(R.string.localizable.portfolio_schedule_tips_title())
                .font(.title2.bold())
                .foregroundColor(Color(R.color.gray2.name))
                .multilineTextAlignment(.leading)
                
            
            Text(R.string.localizable.portfolio_schedule_tips_body())
                .font(.caption)
                .foregroundColor(Color(R.color.gray3.name))
                .multilineTextAlignment(.leading)
            
            VStack(alignment: .leading, spacing: 8){
                Text(R.string.localizable.portfolio_schedule_tips_body2())
                    .font(.body.bold())
                    .foregroundColor(Color(R.color.gray2.name))
                HStack(spacing: 10){
                    ForEach(scheduleTimeTag, id: \.self) { time in
                        Text(time)
                            .padding(2)
                            .padding(.horizontal, 4)
                            .background(Color(R.color.gray3.name))
                            .cornerRadius(16)
                            .foregroundColor(Color(R.color.gray7.name))
                            .font(.caption.bold())
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color(R.color.gray6.name))

            .cornerRadius(16)
            .padding(.bottom)
        
            scheduleCellTips

            Spacer()
        }
        .padding(.top, 16)
        .padding()
    }
    private var scheduleCellTips: some View {
        VStack(spacing: 20){
            VStack(alignment: .leading, spacing: 6){
                HStack{
                    Text(R.string.localizable.schedule_start())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("01 Jan 2024")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                    
                    Text("8:00 AM")
                        .padding(4)
                        .background(Color(R.color.gray3.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
                Divider()
                HStack{
                    Text(R.string.localizable.schedule_end())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("31 May 2024")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                    
                    Text("10:00 AM")
                        .padding(4)
                        .background(Color(R.color.gray3.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
                Divider()
                HStack{
                    Text(R.string.localizable.schedule_interval())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("1")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
                Divider()
                HStack{
                    Text(R.string.localizable.schedule_price())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("100")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
            }
            .padding()
            .background(Color(R.color.gray6.name))
            .cornerRadius(12)
            .font(.caption)
            .multilineTextAlignment(.leading)
            
            VStack(alignment: .leading, spacing: 6){
                HStack{
                    Text(R.string.localizable.schedule_start())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("01 Jan 2024")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                    
                    Text("4:00 PM")
                        .padding(4)
                        .background(Color(R.color.gray3.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
                Divider()
                HStack{
                    Text(R.string.localizable.schedule_end())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("31 May 2024")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                    
                    Text("6:00 PM")
                        .padding(4)
                        .background(Color(R.color.gray3.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
                Divider()
                HStack{
                    Text(R.string.localizable.schedule_interval())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("1")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
                Divider()
                HStack{
                    Text(R.string.localizable.schedule_price())
                        .foregroundColor(Color(R.color.gray2.name))
                    Spacer()
                    
                    Text("100")
                        .padding(4)
                        .background(Color(R.color.gray4.name))
                        .cornerRadius(5)
                        .foregroundColor(Color(R.color.gray7.name))
                }
            }
            .padding()
            .background(Color(R.color.gray6.name))
            .cornerRadius(12)
            .font(.caption)
            .multilineTextAlignment(.leading)
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
//            Toggle(R.string.localizable.schedule_holidays(), isOn: $schedule.holidays)
//                .foregroundColor(Color(R.color.gray3.name))
//                .tint(Color(R.color.gray1.name))
            DatePicker(R.string.localizable.schedule_start(), selection: $schedule.startDate, displayedComponents: [.hourAndMinute, .date])
                .foregroundColor(Color(R.color.gray3.name))
                .padding(.top, 8)
            DatePicker(R.string.localizable.schedule_end(), selection: $schedule.endDate, displayedComponents: [.hourAndMinute, .date])
                .foregroundColor(Color(R.color.gray3.name))
            Picker(R.string.localizable.schedule_interval(), selection: $schedule.timeIntervalSelected) {
                ForEach(interval, id: \.self) { time in
                    Text(timeInterval(intervals: time))
                }
            }
            .pickerStyle(.menu)
            .foregroundColor(Color(R.color.gray3.name))
            .accentColor(.primary)
            
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
    private func timeInterval(intervals: String) -> String {
        switch intervals {
        case "30" :
            return "1/2"
        case "60" :
            return "1"
        case "120" :
            return "2"
        case "180" :
            return "3"
        case "360" :
            return "6"
        case "480" :
            return "8"
        case "720" :
            return "12"
        default:
            return "1"
        }
    }
}

struct PortfolioScheduleView_Previews: PreviewProvider {
    private static let viewModel = MockViewModel()

    static var previews: some View {
        PortfolioScheduleView(with: viewModel)
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
