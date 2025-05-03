import SwiftUI

struct TypeNotesView: View {
    @Binding var newNote: String
    @Binding var noteExists: Bool
    @Binding var showNoteExists: Bool
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
            List {
                Section(header: Text("Finance")) {
                    NavigationLink(destination: BankNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Bank", image: "dollarsign.bank.building.fill", color: .red)
                    }
                    .listRowBackground(Color.backgroundSearchBar)
                  
                    NavigationLink(destination: CreditCardNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Credit Card", image: "creditcard.fill", color: .green)
                    }
                  
                    NavigationLink(destination: PaymentNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Payments", image: "banknote.fill", color: .blue)
                    }
                    
                }
                .listRowBackground(Color.backgroundSearchBar)
                
                Section(header: Text("Lifestyle")) {
                    NavigationLink(destination: ShoppingNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Shopping", image: "cart.fill", color: .purple)
                    }
                    
                    NavigationLink(destination: WorkNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Work", image: "briefcase.fill", color: .orange)
                    }
                   
                    NavigationLink(destination: MessageNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Messages", image: "ellipsis.message.fill", color: .yellow)
                    }
                    
                }
                .listRowBackground(Color.backgroundSearchBar)
                
                Section(header: Text("Health & Travel")) {
                    NavigationLink(destination: HealthNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Health", image: "heart.fill", color: .pink)
                    }
                   
                    NavigationLink(destination: TravelNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Travel", image: "airplane", color: .teal)
                    }
                   
                    NavigationLink(destination: PersonalNotesView(notesViewModel: viewModel, newNote: $newNote, noteExists: $noteExists, showNoteExists: $showNoteExists, isPresented: $isPresented)) {
                        CardRow(title: "Personal", image: "person.fill", color: .indigo)
                    }
                }
                .listRowBackground(Color.backgroundSearchBar)
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.backgroundHomePage)
    }
}

private struct CardRow: View {
    let title: String
    let image: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 28, height: 28)
                
                Image(systemName: image)
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
            }
            
            Text(title)
                .foregroundStyle(.primary)
                .font(.body)
                
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
