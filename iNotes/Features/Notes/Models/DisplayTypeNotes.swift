enum DisplayTypeNotes: String, CaseIterable {
    case List
    case Grid

    var iconName: String {
        switch self {
        case .List:
            return "list.bullet"
        case .Grid:
            return "square.grid.2x2"
        }
    }

    var displayName: String {
        switch self {
        case .Grid:
            return "Grid"
        case .List:
            return "List"
        }
    }
}
