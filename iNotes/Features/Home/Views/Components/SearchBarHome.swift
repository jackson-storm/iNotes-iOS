import SwiftUI

struct SearchBarHomeView: View {
    @Binding var searchText: String
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backgroundButton)
                .frame(height: searchText.isEmpty ? 45 : 50)
            
            if searchText.isEmpty {
                Text("Search")
                    .foregroundColor(.gray)
                    .padding(.leading, 45)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                    }
                    .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
