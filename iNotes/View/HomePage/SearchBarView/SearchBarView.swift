import SwiftUI

struct SearchBarView: View {
    @Binding var searchBarText: String
    
    var body: some View {
        HStack(spacing: 15) {
            if searchBarText.isEmpty {
                ProfileImage()
            }
            
            CustomTextField(searchText: $searchBarText)
            
            if searchBarText.isEmpty {
                HeaderMenuView()
            }
        }
        .animation(.bouncy(duration: 0.5), value: searchBarText)
        .padding(.horizontal, 15)
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    SearchBarView(searchBarText: $searchText)
}
