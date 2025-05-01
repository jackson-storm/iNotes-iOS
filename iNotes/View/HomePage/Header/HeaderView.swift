import SwiftUI

struct HeaderView: View {
    @Binding var searchBarText: String
    
    var body: some View {
        HStack(spacing: 15) {
            if searchBarText.isEmpty {
                ProfileImage()
            }
            
            CustomSearchBar(searchText: $searchBarText)
            
            if searchBarText.isEmpty {
                HeaderMenuView()
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
        .padding(.horizontal, 20)
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    HeaderView(searchBarText: $searchText)
}
