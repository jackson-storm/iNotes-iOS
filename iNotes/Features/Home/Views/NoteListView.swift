import SwiftUI

struct NotesListView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        VStack {
            if notesViewModel.notes.isEmpty {
                Spacer()
                
                VStack(spacing: 10) {
                    Image(systemName: "menucard")
                    Text("Empty notes")
                        
                }
                .padding(.bottom, 50)
                .foregroundColor(.gray)
                .font(.system(size: 24))
                
            } else {
                ScrollView {
                    NotesCardView(notesViewModel: notesViewModel)
                }
            }
            Spacer()
        }
    }
}


private struct NotesCardView: View {
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
    HomeView()
}
