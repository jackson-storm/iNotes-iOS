import SwiftUI

struct EditCustomTab: View {
    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            
            Button(action: {
                // действие для жирного текста
            }) {
                Image(systemName: "bold")
            }

            Button(action: {
                // действие для курсивного текста
            }) {
                Image(systemName: "italic")
            }

            Button(action: {
                // действие для подчёркивания текста
            }) {
                Image(systemName: "underline")
            }

            Button(action: {
                // действие для изменения размера шрифта
            }) {
                Image(systemName: "textformat.size")
            }

            Button(action: {
                // действие для выделения текста
            }) {
                Image(systemName: "highlighter")
            }

            Button(action: {
                // действие
            }) {
                Image(systemName: "text.alignleft")
            }
            
            Button(action: {
                // действие для выравнивания по центру
            }) {
                Image(systemName: "text.aligncenter")
            }
            
            Button(action: {
                // действие для выравнивания по центру
            }) {
                Image(systemName: "text.alignright")
            }

            Spacer()
        }
        .font(.system(size: 20))
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.backgroundComponents)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
                .frame(height: 60)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ContentView()
}
