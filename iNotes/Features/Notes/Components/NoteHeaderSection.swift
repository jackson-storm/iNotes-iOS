import SwiftUI

struct NoteHeaderSection: View {
    @Binding var title: String
    @Binding var isSaved: Bool
    
    let lastEdited: Date
    
    var body: some View {
        HStack {
            TextField("Title", text: $title)
                .bold()
                .font(.system(size: 26))
                .padding(.horizontal)
                .padding(.top)
            
            VStack(alignment: .trailing, spacing: 0) {
                Text(lastEdited.formatted(date: .abbreviated, time: .shortened))
                Text(isSaved ? "💾 Saved" : "✏️ Editing...")
                    .padding(.vertical, 10)
            }
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .padding(.trailing)
            .padding(.top)
        }
    }
}

#Preview {
    ContentView()
}
