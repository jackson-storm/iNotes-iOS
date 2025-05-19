import SwiftUI

struct SearchBarEditNotes: View {
    @Binding var searchTextEditNotes: String
    @Binding var isActiveSearch: Bool
    @Binding var description: String
    
    @Binding var matchRanges: [NSRange]
    @Binding var currentMatchIndex: Int
    
    private var searchMatchesCount: Int {
        guard isActiveSearch, !searchTextEditNotes.isEmpty else { return 0 }
        let words = description.lowercased().components(separatedBy: .whitespacesAndNewlines)
        return words.filter { $0.contains(searchTextEditNotes.lowercased()) }.count
    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.backgroundComponents)
                            .stroke(.gray.opacity(0.1), lineWidth: 1)
                            .frame(height: 40)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                            
                            
                            TextField("Search", text: $searchTextEditNotes)
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
                        .padding(.horizontal, 10)
                    }
                }
                .animation(.bouncy, value: searchTextEditNotes)
                
                HStack {
                    Text("Found: \(searchMatchesCount) word\(searchMatchesCount == 1 ? "" : "s")")
                        .font(.caption)
                        .padding(.leading, 10)
                        .foregroundStyle(searchMatchesCount > 0 ? .green : .red)
                    
                    Spacer()
                    
                }
            }
            HStack(spacing: 20) {
                if !searchTextEditNotes.isEmpty {
                    Button {
                        currentMatchIndex = (currentMatchIndex - 1 + matchRanges.count) % matchRanges.count
                    } label: {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 20))
                        
                    }
                    
                    Button {
                        currentMatchIndex = (currentMatchIndex + 1) % matchRanges.count
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20))
                        
                    }
                    
                    Text("\(currentMatchIndex + 1)/\(matchRanges.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                
                Button {
                    isActiveSearch = false
                    matchRanges = []
                } label: {
                    Text("Ready")
                        .bold()
                }
            }
            .padding(.bottom, 20)
            .padding(.leading, 10)
        }
        .padding(10)
    }
}

