import SwiftUI

struct SelectTextSize: View {
    @Binding var textScale: Double
    @Binding var isActiveTextSize: Bool
        
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundComponents)
                    .stroke(.gray.opacity(0.1), lineWidth: 1)
                    .frame(height: 40)
                
                HStack {
                    Image(systemName: "textformat.size")
                    
                    Spacer()
                    
                    Text("font size:")
                    
                        Text("\(Int(textScale))%")
                        .overlay (
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.secondary.opacity(0.2))
                                .frame(height: 28)
                        )
                         
                    Spacer()
                }
                .padding(.horizontal, 10)
            }
            HStack(spacing: 10) {
                Button {
                    if textScale < 150 {
                        textScale += 5
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .padding(5)
                        .contentShape(Rectangle())
                }
                Button {
                    if textScale > 50 {
                        textScale -= 5
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 20))
                        .padding(5)
                        .contentShape(Rectangle())
                }
                Button {
                    isActiveTextSize = false
                } label: {
                    Text("Ready")
                        .bold()
                }
            }
        }
        .padding(10)
    }
}
