import SwiftUI

struct NoteHeaderSection: View {
    @Binding var title: String
    let lastEdited: Date
    
    var body: some View {
        HStack {
            TextField("Title", text: $title)
                .bold()
                .font(.system(size: 26))
                .padding(.horizontal)
                .padding(.top)
            
            Text(lastEdited.formatted(date: .abbreviated, time: .shortened))
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.trailing)
                .padding(.top)
        }
    }
}
