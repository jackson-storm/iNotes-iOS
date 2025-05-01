import SwiftUI

struct NotesCardView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(notesViewModel.notes, id: \.self) { note in
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.backgroundNotes)
                        .frame(minHeight: 180)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    
                    VStack(alignment: .center) {
                        Text(note)
                            .lineLimit(1)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 5)
                            .padding(.top)
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Image(systemName: "list.bullet.rectangle.portrait")
                            Text("Empty note")
                               
                        } .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text("Edited")
                                
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NotesCardView(notesViewModel: .init())
}
