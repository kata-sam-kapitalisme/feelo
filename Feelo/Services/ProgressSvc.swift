import Foundation

enum ProgressSvc {
    private static let key = "cleared_level_ids"

    static func isDone(_ id: String) -> Bool {
        ids.contains(id)
    }

    static func markDone(_ id: String) {
        var set = ids
        set.insert(id)

        UserDefaults.standard.set(
            Array(set),
            forKey: key
        )
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    private static var ids: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }
}
