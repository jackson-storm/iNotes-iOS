enum DisplayTypeNotes: String, CaseIterable {
    case list
    case grid

    var iconName: String {
        switch self {
        case .list:
            return "list.bullet"
        case .grid:
            return "square.grid.2x2"
        }
    }

    var displayName: String {
        switch self {
        case .grid:
            return "Grid"
        case .list:
            return "List"
        }
    }
}
