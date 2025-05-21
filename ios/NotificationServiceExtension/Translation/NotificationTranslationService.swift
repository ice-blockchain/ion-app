// SPDX-License-Identifier: ice License 1.0

import Foundation

enum Constants {
    static let appGroupKey = "APP_GROUP"
    static let currentPubkeyKey = "current_master_pubkey"
    static let translationCacheDirName = "TranslationCache"
    static let translationsPath = "ion-app_push-notifications_translations"
    static let appLocaleKey = "app_locale"
    static let fallbackLocale = "en_US"
}

class NotificationTranslationService {
    static let shared = NotificationTranslationService()

    private let translator: Translator<PushNotificationTranslations>

    private init() {
        let appGroupIdentifier = Bundle.main.object(forInfoDictionaryKey: Constants.appGroupKey) as! String
        let userDefaults = UserDefaults(suiteName: appGroupIdentifier) ?? UserDefaults.standard

        let fileManager = FileManager.default
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
        let cacheDirectory =
            containerURL?.appendingPathComponent(Constants.translationCacheDirName, isDirectory: true)
            ?? URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(Constants.translationCacheDirName)
        
        let appLocale = userDefaults.string(forKey: Constants.appLocaleKey) ?? Constants.fallbackLocale

        let repository = TranslationsRepository<PushNotificationTranslations>(
            ionOrigin: Environment.ionOrigin,
            path: Constants.translationsPath,
            userDefaults: userDefaults,
            cacheDirectory: cacheDirectory,
            cacheMaxAge: TimeInterval(Environment.pushTranslationsCacheMinutes * 60)
        )

        print(appLocale)

        self.translator = Translator<PushNotificationTranslations>(
            translationsRepository: repository,
            locale: Locale(identifier: appLocale)
        )
    }

    func translate(_ pushPayload: [AnyHashable: Any]) async -> (title: String?, body: String?) {
        guard let currentPubkey = getCurrentPubkey() else {
            print("No current pubkey found, cannot validate notification")
            return (title: nil, body: nil)
        }

        guard let data = parsePayload(from: pushPayload) else {
            print("Failed to parse push payload")
            return (title: nil, body: nil)
        }

        let dataIsValid = data.validate(currentPubkey: currentPubkey)

        if !dataIsValid {
            print("Data validation failed")
            return (title: nil, body: nil)
        }

        guard let notificationType = data.getNotificationType(currentPubkey: currentPubkey) else {
            print("Unknown notification type")
            return (title: nil, body: nil)
        }

        guard let (title, body) = await getNotificationTranslation(for: notificationType) else {
            print("Failed to get notification translation")
            return (title: nil, body: nil)
        }

        let placeholders = data.placeholders

        let result = (
            title: replacePlaceholders(title, placeholders),
            body: replacePlaceholders(body, placeholders)
        )

        if hasPlaceholders(result.title) || hasPlaceholders(result.body) {
            print("Not all placeholders were replaced")
            return (title: nil, body: nil)
        }

        return result
    }

    // MARK: - Private helper methods

    private func getCurrentPubkey() -> String? {
        guard let appGroupIdentifier = Bundle.main.object(forInfoDictionaryKey: Constants.appGroupKey) as? String else {
            print("App group identifier not found in Info.plist")
            return nil
        }

        let userDefaults = UserDefaults(suiteName: appGroupIdentifier)
        return userDefaults?.string(forKey: Constants.currentPubkeyKey)
    }

    private func parsePayload(from pushPayload: [AnyHashable: Any]) -> IonConnectPushDataPayload? {
        do {
            let data = try JSONSerialization.data(withJSONObject: pushPayload)
            let payload = try JSONDecoder().decode(IonConnectPushDataPayload.self, from: data)

            return payload
        } catch {
            print("Error decoding push payload: \(error)")
            return nil
        }
    }

    private func getNotificationTranslation(for notificationType: PushNotificationType) async -> (title: String, body: String)?
    {
        do {
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
                print("Missing translation for notification type: \(notificationType)")
                return nil
            }

            return (title: title, body: body)
        } catch {
            print("Unexpected error getting translation: \(error)")
            return nil
        }
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
