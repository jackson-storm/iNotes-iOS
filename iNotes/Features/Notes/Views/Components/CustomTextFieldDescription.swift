import SwiftUI

struct CustomTextFieldDescriptionView: View {
    @State private var noteText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 5)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.backgroundSearchBar)
                    .frame(height: 260)
                
                ZStack(alignment: .topLeading) {
                    if noteText.isEmpty {
                        Text("Enter description")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 13)
                    }
                    TextEditor(text: $noteText)
                        .scrollContentBackground(.hidden)
                        .frame(height: 250)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .opacity(noteText.isEmpty ? 0.7 : 1)
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    CustomTextFieldDescriptionView()
}
