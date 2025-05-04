import SwiftUI

struct TypeNotesView: View {
    @Binding var newNote: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SectionView(header: "Finance") {
                    NavigationLink(destination: BankNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Bank", image: "dollarsign.bank.building.fill", color: .red)
                    }
                    CustomDivider()
                    
                    NavigationLink(destination: CreditCardNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Credit Card", image: "creditcard.fill", color: .green)
                    }
                    CustomDivider()
                    
                    NavigationLink(destination: PaymentNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Payments", image: "banknote.fill", color: .blue)
                    }
                }
                
                SectionView(header: "Lifestyle") {
                    NavigationLink(destination: ShoppingNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Shopping", image: "cart.fill", color: .purple)
                    }
                    CustomDivider()
                    
                    NavigationLink(destination: WorkNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Work", image: "briefcase.fill", color: .orange)
                    }
                    CustomDivider()
                    
                    NavigationLink(destination: MessageNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Messages", image: "ellipsis.message.fill", color: .yellow)
                    }
                }
                
                SectionView(header: "Health & Travel") {
                    NavigationLink(destination: HealthNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Health", image: "heart.fill", color: .pink)
                    }
                    CustomDivider()
                    
                    NavigationLink(destination: TravelNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Travel", image: "airplane", color: .teal)
                    }
                    CustomDivider()
                    
                    NavigationLink(destination: PersonalNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Personal", image: "person.fill", color: .indigo)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .foregroundStyle(.primary)
        }
    }
}

private struct CardRow: View {
    let title: String
    let image: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: 30, height: 30)
                
                Image(systemName: image)
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
            }
            
            Text(title)
                .foregroundStyle(.primary)
                .font(.body)
                
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
    }
}

private struct SectionView<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(header)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                content
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.backgroundComponents)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

private struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .fill(.gray.opacity(0.1))
            .frame(height: 0.5)
    }
}

#Preview {
    ContentView()
}
