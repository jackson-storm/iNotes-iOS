import SwiftUI

struct TypeNotesView: View {
    
    @Binding var noteTitle: String
    @Binding var description: String
    @Binding var isPresented: Bool
    
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SectionView(header: "Finance") {
                    categoryLink(title: "Bank", image: "dollarsign.bank.building.fill", color: .red, category: .banks)
                    CustomDivider()
                    
                    categoryLink(title: "Credit Card", image: "creditcard.fill", color: .green, category: .creditCards)
                    CustomDivider()
                    
                    categoryLink(title: "Payments", image: "banknote.fill", color: .blue, category: .payments)
                }
                
                SectionView(header: "Lifestyle") {
                    categoryLink(title: "Shopping", image: "cart.fill", color: .purple, category: .shopping)
                    CustomDivider()
                    
                    categoryLink(title: "Work", image: "briefcase.fill", color: .orange, category: .work)
                    CustomDivider()
                    
                    categoryLink(title: "Messages", image: "ellipsis.message.fill", color: .yellow, category: .messages)
                }
                
                SectionView(header: "Health & Travel") {
                    categoryLink(title: "Health", image: "heart.fill", color: .pink, category: .health)
                    CustomDivider()
                    
                    categoryLink(title: "Travel", image: "airplane", color: .teal, category: .travel)
                    CustomDivider()
                    
                    categoryLink(title: "Personal", image: "person.fill", color: .indigo, category: .personal)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .foregroundStyle(.primary)
        }
    }
    
    @ViewBuilder
    private func categoryLink(title: String, image: String, color: Color, category: NoteCategory) -> some View {
        NavigationLink(destination:
            NoteCategoryEditView(
                notesViewModel: viewModel,
                noteTitle: $noteTitle,
                description: $description,
                isPresented: $isPresented,
                category: category,
                categoryIcon: image,
                categoryColor: color,
                categoryLabel: title
            )
        ) {
            CardRow(title: title, image: image, color: color)
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
