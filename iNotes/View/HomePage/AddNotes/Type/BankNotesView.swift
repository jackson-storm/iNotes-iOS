import SwiftUI

struct BankNotesView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.backgroundHomePage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Заметки для банка")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Bank")
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

