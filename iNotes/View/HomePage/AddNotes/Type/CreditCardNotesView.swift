import SwiftUI

struct CreditCardNotesView: View {
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
                    Text("Credit Card")
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
