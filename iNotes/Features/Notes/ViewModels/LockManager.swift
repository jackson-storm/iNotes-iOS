import SwiftUI

protocol LockManager {
    func saveLock(for noteID: UUID, isLock: Bool)
    func loadLock(for noteID: UUID) -> Bool
}

final class UserDefaultsLockManager: LockManager {
    func saveLock(for noteID: UUID, isLock: Bool) {
        UserDefaults.standard.set(isLock, forKey: "isLock_\(noteID.uuidString)")
    }

    func loadLock(for noteID: UUID) -> Bool {
        UserDefaults.standard.bool(forKey: "isLock_\(noteID.uuidString)")
    }
}
