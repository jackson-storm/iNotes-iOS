import SwiftUI

struct SearchBarAddNotesView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundSearchBar)
                .frame(height: 45)
            
            if searchText.isEmpty {
                Text("Notes title")
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
            }
            
            HStack {
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .animation(.bouncy, value: searchText)
            .padding(.horizontal, 15)
        }
    }
}
