import SwiftUI

struct SearchBarEditNotes: View {
    @Binding var searchTextEditNotes: String
    @Binding var isActiveSearch: Bool
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundComponents)
                    .stroke(.gray.opacity(0.1), lineWidth: 1)
                    .frame(height: 40)
                
                if searchTextEditNotes.isEmpty {
                    Text("Search")
                        .foregroundColor(.gray)
                        .padding(.leading, 45)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray)
                    
                    TextField("", text: $searchTextEditNotes)
                        .foregroundColor(.primary)
                    
                    if !searchTextEditNotes.isEmpty {
                        Button(action: {
                            searchTextEditNotes = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
                        }
                        .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 15)
            }
            Button {
                isActiveSearch = false
            } label: {
                Text("Ready")
                    .bold()
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

