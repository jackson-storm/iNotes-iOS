import SwiftUI

struct HorizontalFilterView: View {
    @State private var selection: Int = 0
    
    private let filters = [
        "All",
        "Banks",
        "Credit Cards",
        "Payments",
        "Shopping",
        "Work",
        "Messages",
        "Health",
        "Travel",
        "Personal"
    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters.indices, id: \.self) { index in
                        Button(action: {
                            selection = index
                        }) {
                            HStack(spacing: 8) {
                                Text(filters[index])
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(selection == index ? .white : .primary)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(selection == index ? Color.backgroundSelected : Color.backgroundSearchBar)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selection)
    }
}

#Preview {
    HorizontalFilterView()
}
