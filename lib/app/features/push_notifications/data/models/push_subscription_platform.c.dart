// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';

part 'push_subscription_platform.c.freezed.dart';

enum PushSubscriptionPlatformValue { android, ios }

@freezed
class PushSubscriptionPlatform with _$PushSubscriptionPlatform {
  const factory PushSubscriptionPlatform({
    required PushSubscriptionPlatformValue value,
  }) = _PushSubscriptionPlatform;

  const PushSubscriptionPlatform._();

  factory PushSubscriptionPlatform.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 2) {
      throw IncorrectEventTagException(tag: tag.toString());
    }
    return PushSubscriptionPlatform(value: PushSubscriptionPlatformValue.values.byName(tag[1]));
  }

  factory PushSubscriptionPlatform.forPlatform() {
    if (!kIsWeb && Platform.isAndroid) {
      return const PushSubscriptionPlatform(value: PushSubscriptionPlatformValue.android);
    } else if (!kIsWeb && Platform.isIOS) {
      return const PushSubscriptionPlatform(value: PushSubscriptionPlatformValue.ios);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  List<String> toTag() {
    return [tagName, value.name];
  }

  static const String tagName = 't';
}
