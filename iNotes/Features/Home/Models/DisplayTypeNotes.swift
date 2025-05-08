enum DisplayTypeNotes: String, CaseIterable {
    case list
    case grid
    case timeLine

    var iconName: String {
        switch self {
        case .list:
            return "list.bullet.rectangle"
        case .grid:
            return "square.grid.2x2"
        case .timeLine:
            return "line.3.horizontal.decrease.circle" 
        }
    }

    var displayName: String {
        switch self {
        case .grid:
            return "Grid"
        case .list:
            return "List"
        case .timeLine:
            return "TimeLine"
        }
    }
}
