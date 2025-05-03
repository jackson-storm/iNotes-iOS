import SwiftUI

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let content: String
    let lastEdited: Date
    
    init(title: String, content: String, lastEdited: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.lastEdited = lastEdited
    }
}
