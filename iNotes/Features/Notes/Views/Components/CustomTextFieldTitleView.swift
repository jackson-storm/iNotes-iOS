import SwiftUI

struct CustomTextFieldTitle: View {
    @Binding var newNote: String
    @Binding var noteExists: Bool
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd HH:mm")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Title")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Text("\(Date(), formatter: dateFormatter)")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundSearchBar)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(noteExists ? Color.red : Color.clear, lineWidth: 2)
                    )
                    .frame(height: 50)
                
                if newNote.isEmpty {
                    Text("Enter title")
                        .foregroundColor(.secondary)
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
                    .animation(.easeInOut, value: noteExists)
            }
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut, value: noteExists)
        .onAppear {
            newNote = ""
            noteExists = false
        }
    }
}

#Preview {
    CustomTextFieldTitle(newNote: .constant(""), noteExists: .constant(false))
}
