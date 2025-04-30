import SwiftUI

struct CustomTextFieldAddNotesView: View {
    @Binding var newNote: String
    @Binding var noteExists: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundSearchBar)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(noteExists ? Color.red : Color.clear, lineWidth: 2)
                    )
                    .frame(height: 45)
                
                if newNote.isEmpty {
                    Text("Notes title")
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                }
                
                HStack {
                    TextField("", text: $newNote)
                        .foregroundColor(.primary)
                    
                    if !newNote.isEmpty {
                        Button(action: {
                            newNote = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .animation(.bouncy, value: newNote)
                .padding(.horizontal, 15)
            }
            
            if noteExists {
                Text("This note title already exists.")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 15)
                    .transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut, value: noteExists)
    }
}

#Preview {
    CustomTextFieldAddNotesView(newNote: .constant(""), noteExists: .constant(false))
}
