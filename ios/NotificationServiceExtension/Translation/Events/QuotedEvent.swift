// SPDX-License-Identifier: ice License 1.0

import Foundation

protocol QuotedEvent {
    var eventReference: EventReference { get }
}

class QuotedEventFactory {
    static func fromTag(_ tag: [String]) throws -> QuotedEvent {
        switch tag[0] {
        case QuotedReplaceableEvent.tagName:
            return try QuotedReplaceableEvent.fromTag(tag)
        case QuotedImmutableEvent.tagName:
            return try QuotedImmutableEvent.fromTag(tag)
        default:
            throw IncorrectEventTagNameException(
                actual: tag[0],
                expected: "\(QuotedReplaceableEvent.tagName) or \(QuotedImmutableEvent.tagName)"
            )
        }
    }
}

class QuotedReplaceableEvent: QuotedEvent {
    let eventReference: EventReference

    static let tagName = "Q"

    init(eventReference: ReplaceableEventReference) {
        self.eventReference = eventReference
    }

    static func fromTag(_ tag: [String]) throws -> QuotedReplaceableEvent {
        if tag[0] != tagName {
            throw IncorrectEventTagNameException(actual: tag[0], expected: tagName)
        }

        if tag.count < 4 {
            throw IncorrectEventTagException(tag: tag.joined(separator: ","))
        }

        return QuotedReplaceableEvent(
            eventReference: ReplaceableEventReference.fromString(tag[1])
        )
    }
}

class QuotedImmutableEvent: QuotedEvent {
    let eventReference: EventReference

    static let tagName = "q"

    init(eventReference: ImmutableEventReference) {
        self.eventReference = eventReference
    }

    static func fromTag(_ tag: [String]) throws -> QuotedImmutableEvent {
        if tag[0] != tagName {
            throw IncorrectEventTagNameException(actual: tag[0], expected: tagName)
        }

        if tag.count < 4 {
            throw IncorrectEventTagException(tag: tag.joined(separator: ","))
        }

        let id = tag[1]
        let pubkey = tag.count > 3 ? tag[3] : ""

        return QuotedImmutableEvent(
            eventReference: ImmutableEventReference(id: id, pubkey: pubkey)
        )
    }
}
