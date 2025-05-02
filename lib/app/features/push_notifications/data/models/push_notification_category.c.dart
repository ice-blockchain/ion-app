import 'package:ion/app/features/ion_connect/ion_connect.dart';

sealed class PushNotificationCategory {
  const PushNotificationCategory();
}

abstract class IonConnectPushNotificationCategory {
  RequestFilter get requestFilter;
}

abstract class FcmTopicPushNotificationCategory {
  String get topic;
}

class PostsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const PostsPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class MentionsAndRepliesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const MentionsAndRepliesPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class RepostsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const RepostsPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class LikesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const LikesPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class NewFollowersPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const NewFollowersPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class DirectMessagesPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const DirectMessagesPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class GroupChatsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const GroupChatsPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class ChannelsPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const ChannelsPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class PaymentRequestPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const PaymentRequestPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class PaymentReceivedPushCategory extends PushNotificationCategory
    implements IonConnectPushNotificationCategory {
  const PaymentReceivedPushCategory();

  @override
  RequestFilter get requestFilter => const RequestFilter();
}

class UpdatesPushCategory extends PushNotificationCategory
    implements FcmTopicPushNotificationCategory {
  const UpdatesPushCategory();

  @override
  String get topic => 'ion_updates_topic';
}
