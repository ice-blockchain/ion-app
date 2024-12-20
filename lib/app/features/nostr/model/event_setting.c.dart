// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'event_setting.c.freezed.dart';

abstract class EventSetting {
  factory EventSetting.fromTag(List<String> tag) {
    if (tag[0] != EventSetting.settingTagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: settingTagName);
    }
    if (tag.length < 4) {
      throw IncorrectEventTagException(tag: tag.toString());
    }

    switch (tag[1]) {
      case WhoCanReplyEventSetting.tagName:
        return WhoCanReplyEventSetting.fromTag(tag);
      default:
        throw IncorrectEventTagException(tag: tag.toString());
    }
  }

  List<String> toTag();

  static const String settingTagName = 'settings';
}

@freezed
class WhoCanReplyEventSetting with _$WhoCanReplyEventSetting implements EventSetting {
  const factory WhoCanReplyEventSetting({
    required String value,
  }) = _WhoCanReplyEventSetting;

  const WhoCanReplyEventSetting._();

  /// https://github.com/ice-blockchain/subzero/blob/master/.ion-connect-protocol/ICIP-4000.md#settings-tag
  factory WhoCanReplyEventSetting.fromTag(List<String> tag) {
    if (tag[0] != EventSetting.settingTagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: EventSetting.settingTagName);
    }
    if (tag.length < 4) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return WhoCanReplyEventSetting(value: tag[2]);
  }

  @override
  List<String> toTag() {
    return [
      EventSetting.settingTagName,
      tagName,
      value,
      (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    ];
  }

  static const String tagName = 'who_can_reply';
}
