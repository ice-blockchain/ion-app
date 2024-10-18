// SPDX-License-Identifier: ice License 1.0

class RecentChatDataModel {
  RecentChatDataModel(this.sender, this.unreadMessageCount, this.message);

  final ChatSender sender;
  final int unreadMessageCount;
  final RecentChatMessage message;
}

class ChatSender {
  ChatSender(this.name, this.imageUrl, {required this.isApproved, required this.isIceUser});

  final String name;
  final String imageUrl;
  final bool isApproved;
  final bool isIceUser;
}

sealed class RecentChatMessage {
  RecentChatMessage(this.time);

  final DateTime time;
}

class TextRecentChatMessage extends RecentChatMessage {
  TextRecentChatMessage(this.text, DateTime time) : super(time);
  final String text;
}

class PhotoRecentChatMessage extends RecentChatMessage {
  PhotoRecentChatMessage(super.time);
}

class VoiceRecentChatMessage extends RecentChatMessage {
  VoiceRecentChatMessage(super.time);
}

class ReplayRecentChatMessage extends RecentChatMessage {
  ReplayRecentChatMessage(this.text, DateTime time) : super(time);
  final String text;
}

class VideoRecentChatMessage extends RecentChatMessage {
  VideoRecentChatMessage(super.time);
}

class DocumentRecentChatMessage extends RecentChatMessage {
  DocumentRecentChatMessage(this.fileName, DateTime time) : super(time);
  final String fileName;
}

class LinkRecentChatMessage extends RecentChatMessage {
  LinkRecentChatMessage(this.link, DateTime time) : super(time);
  final String link;
}

class ProfileShareRecentChatMessage extends RecentChatMessage {
  ProfileShareRecentChatMessage(this.displayName, DateTime time) : super(time);
  final String displayName;
}

class PollRecentChatMessage extends RecentChatMessage {
  PollRecentChatMessage(super.time);
}

class MoneyRequestRecentChatMessage extends RecentChatMessage {
  MoneyRequestRecentChatMessage(super.time);
}

final mockConversationData = [
  RecentChatDataModel(
    ChatSender(
      'Mike Planton',
      'https://i.pravatar.cc/150?u=@john',
      isApproved: true,
      isIceUser: false,
    ),
    1,
    TextRecentChatMessage(
      '🪙 In the coming days, we will find out who is behind the creation of Bitcoin! Here we start again!',
      DateTime.now(),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Mark Zuckerberg',
      'https://i.pravatar.cc/150?u=@mark',
      isApproved: false,
      isIceUser: false,
    ),
    0,
    TextRecentChatMessage(
      'We are excited to announce the launch of our new product!',
      DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Manmeet Singh',
      'https://i.pravatar.cc/150?u=@ashish',
      isApproved: false,
      isIceUser: false,
    ),
    0,
    TextRecentChatMessage(
      'Hey, how are you doing?',
      DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Alicia Wernet',
      'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
      isApproved: false,
      isIceUser: true,
    ),
    3,
    PhotoRecentChatMessage(
      DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Manmeet Singh',
      'https://i.pravatar.cc/150?u=@felix',
      isApproved: false,
      isIceUser: false,
    ),
    0,
    TextRecentChatMessage(
      'Hey, how are you doing?',
      DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Ice Open Network',
      'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
      isApproved: true,
      isIceUser: false,
    ),
    3,
    TextRecentChatMessage(
      'Hi ☃️ Snowman, 🚨 Join us for an exclusive AMA session on X Spaces...',
      DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Paul Walker',
      'https://i.pravatar.cc/150?u=@paul',
      isApproved: false,
      isIceUser: false,
    ),
    123,
    VoiceRecentChatMessage(
      DateTime.now().subtract(const Duration(days: 5)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Danzel York',
      'https://i.pravatar.cc/150?u=@danzel',
      isApproved: true,
      isIceUser: false,
    ),
    3,
    ReplayRecentChatMessage(
      'Hi, folks 👋',
      DateTime.now().subtract(const Duration(days: 10)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Manmeet Singh',
      'https://i.pravatar.cc/150?u=@venkat',
      isApproved: false,
      isIceUser: false,
    ),
    0,
    TextRecentChatMessage(
      'Hello, are you there?',
      DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'David Glover',
      'https://i.pravatar.cc/150?u=@david',
      isApproved: false,
      isIceUser: false,
    ),
    123,
    VideoRecentChatMessage(
      DateTime.now().subtract(const Duration(days: 133)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'John Doe',
      'https://i.pravatar.cc/150?u=@john',
      isApproved: true,
      isIceUser: false,
    ),
    0,
    DocumentRecentChatMessage(
      'Whitepaper.pdf',
      DateTime.now().subtract(const Duration(days: 400)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Mike Planton',
      'https://i.pravatar.cc/150?u=@mike',
      isApproved: true,
      isIceUser: false,
    ),
    1,
    LinkRecentChatMessage(
      'https://ice.network',
      DateTime.now().subtract(const Duration(days: 500)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Alicia Wernet',
      'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
      isApproved: false,
      isIceUser: true,
    ),
    0,
    ProfileShareRecentChatMessage(
      'Alicia Wernet',
      DateTime.now().subtract(const Duration(days: 600)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Ice Open Network',
      'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
      isApproved: true,
      isIceUser: true,
    ),
    3,
    PollRecentChatMessage(
      DateTime.now().subtract(const Duration(days: 700)),
    ),
  ),
  RecentChatDataModel(
    ChatSender(
      'Paul Walker',
      'https://i.pravatar.cc/150?u=@paul',
      isApproved: false,
      isIceUser: false,
    ),
    123,
    MoneyRequestRecentChatMessage(
      DateTime.now().subtract(const Duration(days: 800)),
    ),
  ),
];
