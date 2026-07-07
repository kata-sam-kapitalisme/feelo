import Foundation

enum LevelProgress {
    private static let key = "cleared_level_ids"

    static func isCleared(_ id: String) -> Bool {
        clearedIds.contains(id)
    }

    static func markCleared(_ id: String) {
        var ids = clearedIds
        ids.insert(id)
        UserDefaults.standard.set(Array(ids), forKey: key)
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    private static var clearedIds: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }
}
