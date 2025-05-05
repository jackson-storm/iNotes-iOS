import SwiftUI

struct TextFieldTitleView: View {
    @Binding var noteTitle: String
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
                    .fill(Color.backgroundComponents)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(noteExists ? Color.red : Color.gray.opacity(0.1), lineWidth: 1)
                    )
                    .frame(height: 50)
                
                if noteTitle.isEmpty {
                    Text("Enter title")
                        .foregroundColor(.secondary)
                        .padding(.leading, 15)
                }
                
                HStack {
                    TextField("", text: $noteTitle)
                        .foregroundColor(.primary)
                    
                    if !noteTitle.isEmpty {
                        Button(action: {
                            noteTitle = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .animation(.bouncy, value: noteTitle)
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
            noteTitle = ""
            noteExists = false
        }
    }
}

#Preview {
    TextFieldTitleView(noteTitle: .constant(""), noteExists: .constant(false))
}
