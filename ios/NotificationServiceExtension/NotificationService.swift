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
        
        defer {
            Messaging.serviceExtension().populateNotificationContent(
                mutableNotificationContent,
                withContentHandler: contentHandler
            )
        }

        var storage: SharedStorageService

        do {
            storage = try SharedStorageService()
        } catch {
            return
        }

        Task {
            let translation = await NotificationTranslationService(storage: storage).translate(request.content.userInfo)

            if let title = translation.title, let body = translation.body {
                mutableNotificationContent.title = title
                mutableNotificationContent.body = body
            }
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let mutableNotificationContent = mutableNotificationContent {
            contentHandler(mutableNotificationContent)
        }
    }
}
