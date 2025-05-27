import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isSheetPresented: Bool
    @Binding var isSelectionMode: Bool

    var body: some View {
        HStack {
            TabBarButton(icon: (selectedTab != 0) ? "archivebox" : "archivebox.fill", title: "Archive", isSelected: selectedTab == 0) {
                selectedTab = 0
            }

            TabBarButton(icon: (selectedTab != 1) ? "note" : "note.text", title: "Notes", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            .contextMenu {
                Button {
                    selectedTab = 1
                    isSheetPresented = true
                } label: {
                    Label("Add note", systemImage: "plus")
                }

                Button {
                    selectedTab = 1
                    isSelectionMode = true
                } label: {
                    Label("Select notes", systemImage: "checkmark.circle")
                }
            }

            TabBarButton(icon: (selectedTab != 2) ? "gearshape" : "gearshape.fill", title: "Settings", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .padding(.bottom, 28)
        .padding(.horizontal, 10)
        .background(Color.backgroundComponents.opacity(0.6))
    }
}

private struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .accentColor : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ContentView()
}
