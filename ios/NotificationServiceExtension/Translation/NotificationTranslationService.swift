// SPDX-License-Identifier: ice License 1.0

import Foundation

class NotificationTranslationService {
    private let translator: Translator<PushNotificationTranslations>
    private let storage: SharedStorageService
    private let e2eDecryptionService: E2EDecryptionService?

    init(storage: SharedStorageService) {
        self.storage = storage

        let appLocale = storage.getAppLocale()
        let repository = TranslationsRepository<PushNotificationTranslations>(
            ionOrigin: Environment.ionOrigin,
            storage: storage,
            cacheMaxAge: TimeInterval(Environment.pushTranslationsCacheMinutes * 60)
        )

        self.translator = Translator<PushNotificationTranslations>(
            translationsRepository: repository,
            appLocale: appLocale
        )

        if let pubkey = storage.getCurrentPubkey(), let currentIdentityKeyName = storage.getCurrentIdentityKeyName() {
            self.e2eDecryptionService = E2EDecryptionService(
                keychainService: KeychainService(currentIdentityKeyName: currentIdentityKeyName),
                pubkey: pubkey,
            )
        } else {
            self.e2eDecryptionService = nil
        }
    }

    func translate(_ pushPayload: [AnyHashable: Any]) async -> (title: String?, body: String?) {
        guard let currentPubkey = storage.getCurrentPubkey() else {
            NSLog("❌ No current pubkey found, cannot validate notification")
            return (title: nil, body: nil)
        }

        guard let data = await parsePayload(from: pushPayload) else {
            NSLog("❌ Failed to parse push payload")
            return (title: nil, body: nil)
        }

        let dataIsValid = data.validate(currentPubkey: currentPubkey)

        if !dataIsValid {
            NSLog("❌ Data validation failed")
            return (title: nil, body: nil)
        }

        guard let notificationType = data.getNotificationType(currentPubkey: currentPubkey) else {
            NSLog("❌ Unknown notification type")
            return (title: nil, body: nil)
        }

        guard let (title, body) = await getNotificationTranslation(for: notificationType) else {
            NSLog("❌ Failed to get notification translation")
            return (title: nil, body: nil)
        }

        let placeholders = data.placeholders

        let result = (
            title: replacePlaceholders(title, placeholders),
            body: replacePlaceholders(body, placeholders)
        )

        if hasPlaceholders(result.title) || hasPlaceholders(result.body) {
            NSLog("❌ Not all placeholders were replaced")
            return (title: nil, body: nil)
        }

        return result
    }

    // MARK: - Private helper methods

    private func parsePayload(from pushPayload: [AnyHashable: Any]) async -> IonConnectPushDataPayload? {
        do {
            let payload = try await IonConnectPushDataPayload.fromJson(data: pushPayload) { event in
                return try? await self.e2eDecryptionService?.decryptMessage(event)
            }

            return payload
        } catch {
            NSLog("❌ Error decoding push payload: \(error)")
            return nil
        }
    }

    private func getNotificationTranslation(for notificationType: PushNotificationType) async -> (title: String, body: String)?
    {
        let translation = await translator.translate { translations in
            switch notificationType {
            case .reply:
                return translations.reply
            case .mention:
                return translations.mention
            case .repost:
                return translations.repost
            case .like:
                return translations.like
            case .follower:
                return translations.follower
            case .chatMessage:
                return translations.chatMessage
            case .chatReaction:
                return translations.chatReaction
            case .paymentRequest:
                return translations.paymentRequest
            case .paymentReceived:
                return translations.paymentReceived
            }
        }

        guard let translation = translation,
            let title = translation.title,
            let body = translation.body
        else {
            NSLog("❌ Missing translation for notification type: \(notificationType)")
            return nil
        }

        return (title: title, body: body)

    }
    /// Replaces placeholders in the format `{{key}}` within the input string
    /// using corresponding values from the placeholders map.
    private func replacePlaceholders(_ input: String, _ placeholders: [String: String]) -> String {
        let regex = try! NSRegularExpression(pattern: "\\{\\{(.*?)\\}\\}", options: [])
        let nsString = input as NSString
        let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: nsString.length))

        var result = input

        for match in matches.reversed() {
            let fullMatch = nsString.substring(with: match.range)
            let keyRange = match.range(at: 1)

            if keyRange.location != NSNotFound {
                let key = nsString.substring(with: keyRange).trimmingCharacters(in: .whitespacesAndNewlines)
                let replacement = placeholders[key] ?? fullMatch

                let mutableResult = NSMutableString(string: result)
                mutableResult.replaceCharacters(in: match.range, with: replacement)
                result = mutableResult as String
            }
        }

        return result
    }

    private func hasPlaceholders(_ input: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "\\{\\{(.*?)\\}\\}", options: [])
        return regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: (input as NSString).length)) != nil
    }
}
