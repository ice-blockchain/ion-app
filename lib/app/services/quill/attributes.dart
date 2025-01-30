import 'package:flutter_quill/flutter_quill.dart';

class MentionAttribute extends Attribute<String> {
  const MentionAttribute(String mentionValue)
      : super('mention', AttributeScope.inline, mentionValue);

  const MentionAttribute.withValue(String value) : this(value);
}

class HashtagAttribute extends Attribute<String> {
  const HashtagAttribute(String hashtagValue)
      : super('hashtag', AttributeScope.inline, hashtagValue);

  const HashtagAttribute.withValue(String value) : this(value);
}

class CashtagAttribute extends Attribute<String> {
  const CashtagAttribute(String cashtagValue)
      : super('cashtag', AttributeScope.inline, cashtagValue);

  const CashtagAttribute.withValue(String value) : this(value);
}
