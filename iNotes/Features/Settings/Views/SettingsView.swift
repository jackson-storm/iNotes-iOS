import SwiftUI

struct SettingsView: View {
    @Binding var selectedTheme: Theme
    @Binding var selectedTintRawValue: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    TintView(selectedTintRawValue: $selectedTintRawValue)
                    ThemeView(themes: Theme.allCases, selectedTheme: $selectedTheme)
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
        }
        .animation(.bouncy, value: selectedTintRawValue)
        .animation(.bouncy, value: selectedTheme)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(selectedTheme.colorScheme)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Edit") {
                    
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .toolbarBackground(Color(.backgroundComponents), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

private struct ThemeView: View {
    let themes: [Theme]
    
    @Binding var selectedTheme: Theme
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(themes, id: \.self) { theme in
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(theme == selectedTheme ? Color.accentColor.opacity(0.15) : Color.backgroundComponents)
                            .frame(height: 60)
                            .onTapGesture {
                                selectedTheme = theme
                            }
                        
                        Image(systemName: theme.icon)
                            .font(.system(size: 20))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(theme == selectedTheme ? Color.accentColor : Color.gray.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal, 1)
                    
                    Text(theme.rawValue.capitalized)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

private struct TintView: View {
    @Binding var selectedTintRawValue: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.backgroundComponents)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
                .frame(height: 60)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(TintColor.allCases) { option in
                        Circle()
                            .fill(option.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Group {
                                    if selectedTintRawValue == option.rawValue {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 35))
                                    }
                                }
                            )
                            .onTapGesture {
                                selectedTintRawValue = option.rawValue
                            }
                    }
                }
                .padding(.horizontal, 5)
            }
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    ContentView()
}
