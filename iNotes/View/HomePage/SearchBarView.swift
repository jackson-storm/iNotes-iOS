import SwiftUI

struct SearchBarView: View {
    @Binding var searchBarText: String
    
    var body: some View {
        HStack(spacing: 15) {
            if searchBarText.isEmpty {
                ProfileImage()
            }
            
            SearchBar(searchText: $searchBarText)
            
            if searchBarText.isEmpty {
                HeaderMenus()
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
        .padding(.horizontal, 15)
    }
}

private struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundSearchBar)
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
private struct ProfileImage: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            }
            .foregroundStyle(.secondary)
        }
    }
}


private struct HeaderMenus: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 24))
            }
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    SearchBarView(searchBarText: $searchText)
}
