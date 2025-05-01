import SwiftUI

struct TypeNotesView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: BankNotesView()) {
                CardRow(title: "Bank", image: "dollarsign.bank.building.fill", color: .red)
            }
            Divider().padding(.leading, 70)
            NavigationLink(destination: MessageNotesView()) {
                CardRow(title: "Messages", image: "ellipsis.message.fill", color: .yellow)
            }
            Divider().padding(.leading, 70)
            NavigationLink(destination: CreditCardNotesView()) {
                CardRow(title: "Credit Card", image: "creditcard.fill", color: .green)
            }
            Divider().padding(.leading, 70)
            NavigationLink(destination: PaymentNotesView()) {
                CardRow(title: "Payments", image: "banknote.fill", color: .blue)
            }
        }
        .foregroundStyle(.secondary)
        .background(Color.backgroundNotes)
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

private struct CardRow: View {
    let title: String
    let image: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 30, height: 30)
                
                Image(systemName: image)
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
            }
            
            Text(title)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

#Preview {
    TypeNotesView()
}
