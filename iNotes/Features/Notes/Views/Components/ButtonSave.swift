import SwiftUI

struct ButtonSaveView: View {
    var action : () -> Void = {}
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue)
                    .frame(height: 55)
                
                Text("Save")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    ButtonSaveView()
}
