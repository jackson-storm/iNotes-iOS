import SwiftUI

struct SearchBarEditNotes: View {
    @Binding var searchTextEditNotes: String
    @Binding var isActiveSearch: Bool
    @Binding var description: String
    
    private var searchMatchesCount: Int {
        guard isActiveSearch, !searchTextEditNotes.isEmpty else { return 0 }
        let words = description.lowercased().components(separatedBy: .whitespacesAndNewlines)
        return words.filter { $0.contains(searchTextEditNotes.lowercased()) }.count
    }
    
    var body: some View {
        VStack {
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
                .padding(.horizontal, 5)
            }
            .animation(.bouncy, value: searchTextEditNotes)
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        Text("Found: \(searchMatchesCount) word\(searchMatchesCount == 1 ? "" : "s")")
            .font(.caption)
            .padding(.leading, 20)
            .foregroundStyle(searchMatchesCount > 0 ? .green : .red)
    }
}

