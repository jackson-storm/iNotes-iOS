import SwiftUI

enum TintColor: String, CaseIterable, Identifiable {
    case blue, green, orange, red, purple, teal
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .red: return .red
        case .purple: return .purple
        case .teal: return .teal
        }
    }
}
