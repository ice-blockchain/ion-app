// SPDX-License-Identifier: ice License 1.0

class Conversation {
  Conversation(this.sender, this.unreadMessageCount, this.message);

  final ConversationSender sender;
  final int unreadMessageCount;
  final ConversationMessage message;
}

class ConversationSender {
  ConversationSender(this.name, this.imageUrl, {required this.isApproved, required this.isIceUser});

  final String name;
  final String imageUrl;
  final bool isApproved;
  final bool isIceUser;
}

sealed class ConversationMessage {
  ConversationMessage(this.time);

  final DateTime time;
}

class ConversationTextMessage extends ConversationMessage {
  ConversationTextMessage(this.text, DateTime time) : super(time);
  final String text;
}

class ConversationPhotoMessage extends ConversationMessage {
  ConversationPhotoMessage(super.time);
}

class ConversationVoiceMessage extends ConversationMessage {
  ConversationVoiceMessage(super.time);
}

class ConversationReplayMessage extends ConversationMessage {
  ConversationReplayMessage(this.text, DateTime time) : super(time);
  final String text;
}

class ConversationVideoMessage extends ConversationMessage {
  ConversationVideoMessage(super.time);
}

class ConversationDocumentMessage extends ConversationMessage {
  ConversationDocumentMessage(this.fileName, DateTime time) : super(time);
  final String fileName;
}

class ConversationLinkMessage extends ConversationMessage {
  ConversationLinkMessage(this.link, DateTime time) : super(time);
  final String link;
}

class ConversationProfileShareMessage extends ConversationMessage {
  ConversationProfileShareMessage(this.displayName, DateTime time) : super(time);
  final String displayName;
}

class ConversationPollMessage extends ConversationMessage {
  ConversationPollMessage(super.time);
}

class ConversationMoneyRequestMessage extends ConversationMessage {
  ConversationMoneyRequestMessage(super.time);
}
