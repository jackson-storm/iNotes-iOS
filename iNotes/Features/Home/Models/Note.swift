import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var lastEdited: Date
    var createdAt: Date     
    var isLiked: Bool
    var category: NoteCategory
    var secretNotesEnabled: Bool

    init(title: String, description: String, lastEdited: Date = Date(), category: NoteCategory, isLiked: Bool, createAt: Date = Date(), secretNotesEnabled: Bool = false) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.lastEdited = lastEdited
        self.category = category
        self.isLiked = isLiked
        self.createdAt = createAt
        self.secretNotesEnabled = secretNotesEnabled
    }
}
