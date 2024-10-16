// SPDX-License-Identifier: ice License 1.0

class Conversation {
  Conversation(this.sender, this.unreadMessageCount, this.message);

  final ConversationSender sender;
  final int unreadMessageCount;
  final ConversationMessageAbstract message;
}

class ConversationSender {
  ConversationSender(this.name, this.imageUrl, {required this.isApproved, required this.isIceUser});

  final String name;
  final String imageUrl;
  final bool isApproved;
  final bool isIceUser;
}

sealed class ConversationMessageAbstract {
  ConversationMessageAbstract(this.time);

  final DateTime time;
}

//text message
class ConversationTextMessage extends ConversationMessageAbstract {
  ConversationTextMessage(this.text, DateTime time) : super(time);
  final String text;
}

class ConversationPhotoMessage extends ConversationMessageAbstract {
  ConversationPhotoMessage(super.time);
}

final mockConversationData = [
  Conversation(
    ConversationSender(
      'Mike Planton',
      'https://i.pravatar.cc/150?u=@john',
      isApproved: true,
      isIceUser: true,
    ),
    1,
    ConversationTextMessage(
      'Meta has introduced the Movie Gen I -model for video generation',
      DateTime.now(),
    ),
  ),
  Conversation(
    ConversationSender(
      'Alicia Wernet',
      'https://i.pravatar.cc/150?u=@alicia',
      isApproved: true,
      isIceUser: true,
    ),
    1,
    ConversationPhotoMessage(
      DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ),
];
