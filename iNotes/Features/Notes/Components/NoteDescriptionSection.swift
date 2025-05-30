import SwiftUI

struct NoteDescriptionSection: View {
    @Binding var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 5)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.backgroundComponents)
                    .stroke(.gray.opacity(0.1), lineWidth: 1)
                    .frame(height: 360)
                    
                
                ZStack(alignment: .topLeading) {
                    if description.isEmpty {
                        Text("Enter description")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 13)
                    }
                    TextEditor(text: $description)
                        .scrollContentBackground(.hidden)
                        .frame(height: 350)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .opacity(description.isEmpty ? 0.7 : 1)
                }
            }
        }
        .padding(20)
        .onAppear {
            description = ""
        }
    }
}

#Preview {
    ContentView()
}
