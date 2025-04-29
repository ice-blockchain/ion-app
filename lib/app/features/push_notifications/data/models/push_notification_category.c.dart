sealed class PushNotificationCategory {
  const PushNotificationCategory();
}

abstract class IonConnectPushNotificationCategory {}

class PostsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const PostsPushCategory();
}

class MentionsAndRepliesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const MentionsAndRepliesPushCategory();
}

class RepostsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const RepostsPushCategory();
}

class LikesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const LikesPushCategory();
}

class NewFollowersPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const NewFollowersPushCategory();
}

class DirectMessagesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const DirectMessagesPushCategory();
}

class GroupChatsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const GroupChatsPushCategory();
}

class ChannelsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const ChannelsPushCategory();
}

class PaymentRequestPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const PaymentRequestPushCategory();
}

class PaymentReceivedPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const PaymentReceivedPushCategory();
}

class UpdatesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const UpdatesPushCategory();
}
