import SwiftUI

struct CardRowNotesView: View {
    var image: String
    var text: String
    var color: Color
    var font: CGFloat
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 26, height: 26)
                
                Image(systemName: image)
                    .foregroundStyle(.white)
                    .font(.system(size: font))
            }
            
            Text(text)
                .bold()
        }
    }
}
