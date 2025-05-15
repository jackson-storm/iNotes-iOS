enum DeleteActionType: Identifiable {
    case deleteAll
    case deleteSelected
    
    var id: Int {
        switch self {
        case .deleteAll: return 0
        case .deleteSelected: return 1
        }
    }
}

