// SPDX-License-Identifier: ice License 1.0

import Foundation

protocol TranslationWithVersion: Decodable {
    var version: Int { get }
}

struct NotificationTranslation: Decodable {
    let title: String?
    let body: String?
}

struct PushNotificationTranslations: TranslationWithVersion, Decodable {
    let version: Int
    let reply: NotificationTranslation?
    let mention: NotificationTranslation?
    let repost: NotificationTranslation?
    let like: NotificationTranslation?
    let follower: NotificationTranslation?
    let chatReaction: NotificationTranslation?
    let chatMessage: NotificationTranslation?
    let paymentRequest: NotificationTranslation?
    let paymentReceived: NotificationTranslation?
    
    enum CodingKeys: String, CodingKey {
        case version = "_version"
        case reply, mention, repost, like, follower
        case chatReaction, chatMessage, paymentRequest, paymentReceived
    }
}
