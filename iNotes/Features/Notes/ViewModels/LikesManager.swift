import SwiftUI

protocol LikesManager {
    func saveLike(for noteID: UUID, isLiked: Bool)
    func loadLike(for noteID: UUID) -> Bool
}

final class UserDefaultsLikesManager: LikesManager {
    func saveLike(for noteID: UUID, isLiked: Bool) {
        UserDefaults.standard.set(isLiked, forKey: "isLiked_\(noteID.uuidString)")
    }

    func loadLike(for noteID: UUID) -> Bool {
        UserDefaults.standard.bool(forKey: "isLiked_\(noteID.uuidString)")
    }
}
