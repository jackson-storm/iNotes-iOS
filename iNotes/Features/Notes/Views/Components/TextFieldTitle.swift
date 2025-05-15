import SwiftUI

struct TextFieldTitleView: View {
    @Binding var noteTitle: String
    
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
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
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
        }
        .padding(.horizontal, 20)
        .onAppear {
            noteTitle = ""
        }
    }
}

