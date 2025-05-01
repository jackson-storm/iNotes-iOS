import SwiftUI

struct PaymentNotesView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.backgroundHomePage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Заметки для сообщения")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Payments")
                        .bold()
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        
                    }
                }
            }
        }
    }
}
