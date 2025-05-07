import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let lastEdited: Date
    var isLiked: Bool
    var category: NoteCategory
    
    init(title: String, description: String, lastEdited: Date = Date(), category: NoteCategory, isLiked: Bool) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.lastEdited = lastEdited
        self.category = category
        self.isLiked = isLiked
    }
}
