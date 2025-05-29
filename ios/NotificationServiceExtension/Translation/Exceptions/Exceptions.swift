// SPDX-License-Identifier: ice License 1.0

import Foundation

class IONException: Error {
    let code: Int
    let message: String

    init(_ code: Int, _ message: String) {
        self.code = code
        self.message = message
    }

    var localizedDescription: String {
        return "[\(code)] \(message)"
    }
}

class IncorrectEventKindException: IONException {
    init(_ eventInfo: Any, kind: Int) {
        super.init(10006, "Incorrect event \(eventInfo), expected kind \(kind)")
    }
}

class IncorrectEventTagNameException: IONException {
    init(actual: String, expected: String) {
        super.init(10007, "Incorrect event tag \(actual), expected \(expected)")
    }
}

class IncorrectEventTagsException: IONException {
    init(eventId: String) {
        super.init(10011, "Incorrect event \(eventId) tags")
    }
}

class UnknownEventException: IONException {
    init(eventId: String, kind: Int) {
        super.init(10012, "Unknown event \(eventId) with kind \(kind)")
    }
}

class IncorrectEventTagException: IONException {
    init(tag: String) {
        super.init(10013, "Incorrect event tag: \(tag)")
    }
}

class EventMasterPubkeyNotFoundException: IONException {
    init(_ eventId: String) {
        super.init(10022, "Master pubkey is not found in event \(eventId)")
    }
}
