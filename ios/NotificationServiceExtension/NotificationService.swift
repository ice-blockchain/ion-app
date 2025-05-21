// SPDX-License-Identifier: ice License 1.0

import FirebaseMessaging
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var mutableNotificationContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        mutableNotificationContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let mutableNotificationContent = mutableNotificationContent else {
            contentHandler(request.content)
            return
        }

        // Create a Task to handle the async translation
        Task {
            // Use the shared instance to benefit from in-memory caching
            let translation = await NotificationTranslationService.shared.translate(request.content.userInfo)

            if let title = translation.title, let body = translation.body {
                mutableNotificationContent.title = title
                mutableNotificationContent.body = body
            }

            // Call Firebase's service extension after we've processed our translations
            Messaging.serviceExtension().populateNotificationContent(
                mutableNotificationContent,
                withContentHandler: contentHandler
            )
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let mutableNotificationContent = mutableNotificationContent {
            contentHandler(mutableNotificationContent)
        }
    }
}
