import SwiftUI

struct ContentView1: View {
    @State private var selectedDate: Date = Date()
    
    private let calendar = Calendar.current
    
    private func isToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack {
            Text("Selected Date: \(selectedDate, formatter: DateFormatter())")
                .padding()
            
            CalendarView(selectedDate: $selectedDate)
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Text("Calendar")
                .font(.title)
            
            Divider()
            
//            DatePicker("", selection: $selectedDate, displayedComponents: .date)
//                .datePickerStyle(GraphicalDatePickerStyle())
//                .padding(.horizontal)
            
//            HStack {
//                ForEach(1...7, id: \.self) { index in
//                    Text(calendar.shortWeekdaySymbols[(index - 1) % 7])
//                        .frame(maxWidth: .infinity)
//                }
//            }
            
            CalendarGridView()
        }
        .padding()
    }
}

struct CalendarGridView: View {
    
    private let calendar = Calendar.current
    
    private var month: Date {
        let components = calendar.dateComponents([.year, .month])
        return calendar.date(from: components)!
    }
    
    private var startDate: Date {
        let components = calendar.dateComponents([.year, .month], from: month)
        return calendar.date(from: components)!
    }
    
    private var endDate: Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
    }
    
    private func day(for date: Date) -> String {
        let components = calendar.dateComponents([.day], from: date)
        return "\(components.day!)"
    }
    
    private func isToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    private func isDateSelected(_ date: Date) -> Bool {
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private func isDateInCurrentMonth(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: month, toGranularity: .month)
    }
    
    var body: some View {
        VStack {
            ForEach(0..<7, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { column in
                        let date = calendar.date(byAdding: DateComponents(day: (row * 7) + column), to: startDate)!

                        Text(day(for: date))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            //.background(isDateInCurrentMonth(date) ? Color.clear : Color.gray.opacity(0.2))
                            //.foregroundColor(isDateSelected(date) ? .white : .primary)
                            .background(isToday(date: date) ? Color.red : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
            }
        }
    }
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
