import SwiftUI

struct HorizontalCalendarView: View {
    let days: [Date] = {
        var dates = [Date]()
        let calendar = Calendar.current
        let startDate = Date()
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: startDate) {
                dates.append(date)
            }
        }
        return dates
    }()
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(days, id: \.self) { date in
                    VStack {
                        Text(dateFormatter.string(from: date))
                            .font(.caption)
                        
                        Text(dayFormatter.string(from: date))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(monthFormatter.string(from: date))
                            .font(.caption)
                           
                    }
                    .padding()
                    .background(date == selectedDate ? Color.backgroundSelected : Color.clear)
                    .foregroundColor(date == selectedDate ? Color.fontSelected : Color.primary)
                    .cornerRadius(20)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedDate)
            .padding(.horizontal, 20)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }
}

struct HorizontalCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCalendarView()
    }
}
