import SwiftUI

struct SearchBarHomeView: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundComponents)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
                .frame(height: searchText.isEmpty ? 45 : 50)
            
            if searchText.isEmpty {
                Text("Search for notes")
                    .foregroundColor(.gray)
                    .padding(.leading, 50)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
                
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
                
                if searchText.isEmpty {
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "microphone.fill")
                            .imageScale(.medium)
                    }
                    .foregroundStyle(.gray)
                } else {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                    }
                    .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    ContentView()
}
