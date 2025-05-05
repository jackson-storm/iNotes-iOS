import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let lastEdited: Date
    var category: NoteCategory
    
    init(title: String, description: String, lastEdited: Date = Date(), category: NoteCategory) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.lastEdited = lastEdited
        self.category = category
    }
}
