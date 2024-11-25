// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/generated/assets.gen.dart';

enum GroupType {
  public,
  private,
  encrypted;

  String getTitle(BuildContext context) {
    return switch (this) {
      GroupType.public => 'Public',
      GroupType.private => 'Private',
      GroupType.encrypted => 'Encrypted',
    };
  }

  String getDescription(BuildContext context) {
    return switch (this) {
      GroupType.public => 'Public channels are searchable and open to all users.',
      GroupType.private => '',
      // 'Private channels can\'t be found in search and aren\'t end-to-end encrypted.',
      GroupType.encrypted =>
        'End-to-end encryption is used. Only you and the people you communicate with can see the messages.',
    };
  }

  String get icon => switch (this) {
        GroupType.public => Assets.svg.iconChannelType,
        GroupType.private => Assets.svg.iconChannelPrivatetype,
        GroupType.encrypted => Assets.svg.iconChannelType,
      };
}
