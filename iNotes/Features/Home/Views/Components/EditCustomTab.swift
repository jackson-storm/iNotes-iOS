import SwiftUI

struct EditCustomTab: View {
    var saveAction: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
                .frame(height: 60)
            
            Button(action: saveAction) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                        .bold()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
        }
        .padding(.horizontal, 20)
    }
}
