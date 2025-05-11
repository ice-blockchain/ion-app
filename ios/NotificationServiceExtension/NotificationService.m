//  SPDX-License-Identifier: ice License 1.0
//
//  NotificationService.m
//  NotificationServiceExtension
//

#import "NotificationService.h"
#import "FirebaseMessaging.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString *appLocale = [self getAppLocale];

    if (appLocale != nil) {
        // Get translations
        // Match translations with the data in the notification
        self.bestAttemptContent.body = appLocale;
    }
    
    [[FIRMessaging extensionHelper] populateNotificationContent:self.bestAttemptContent withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

- (NSString *)getAppLocale {
    NSString *appGroup = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"APP_GROUP"];
    if (appGroup) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:appGroup];
        NSString *appLocale = [userDefaults objectForKey:@"app_locale"];
        return appLocale;
    }
    return nil;
}

@end
