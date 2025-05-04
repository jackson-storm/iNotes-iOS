import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let lastEdited: Date
    
    init(title: String, description: String, lastEdited: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.lastEdited = lastEdited
    }
}
