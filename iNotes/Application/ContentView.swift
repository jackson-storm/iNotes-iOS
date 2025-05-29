import SwiftUI

struct ContentView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @AppStorage("selectedTheme") private var selectedThemeRawValue = Theme.light.rawValue
    @AppStorage("selectedTintColor") private var selectedTintRawValue = TintColor.blue.rawValue
    
    @State private var selectedNotes: Set<UUID> = []
    @State private var isSelectionMode = false
    @State private var sortType: NotesSortType = .creationDate
    @State private var selectedTab: Int = 1
    @State private var isSheetPresented = false
    @State private var deleteActionType: DeleteActionType?
    
    private var selectedThemeBinding: Binding<Theme> {
        Binding<Theme>(
            get: {
                Theme(rawValue: selectedThemeRawValue) ?? .light
            },
            set: { newTheme in
                selectedThemeRawValue = newTheme.rawValue
            }
        )
    }
    
    private var selectedTint: TintColor {
        get { TintColor(rawValue: selectedTintRawValue) ?? .blue }
        set { selectedTintRawValue = newValue.rawValue }
    }
    
    var body: some View {
        if hasLaunchedBefore {
            NavigationStack {
                HomeView(
                    isSelectionMode: $isSelectionMode,
                    selectedNotes: $selectedNotes,
                    sortType: $sortType,
                    selectedTab: $selectedTab,
                    isSheetPresented: $isSheetPresented,
                    selectedTheme: selectedThemeBinding,
                    selectedTintRawValue: $selectedTintRawValue,
                    deleteActionType: $deleteActionType
                )
            }
            .tint(selectedTint.color)
        }
    }
}
