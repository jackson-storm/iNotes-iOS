import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    
    var body: some View {
        HStack(spacing: 15) {
            if searchBarText.isEmpty {
                HeaderProfileImage()
            }
            
            SearchBarView(searchText: $searchBarText)
            
            if searchBarText.isEmpty {
                HeaderButtonMenuView()
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
        .padding(.horizontal, 20)
    }
}

private struct HeaderProfileImage: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "person.circle")
                    .font(.system(size: 24))
            }
            .foregroundStyle(Color.primary)
        }
    }
}

private struct HeaderButtonMenuView: View {
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
            }
            .foregroundStyle(Color.primary)
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    HeaderView(searchBarText: $searchText)
}
