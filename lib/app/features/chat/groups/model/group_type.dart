// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';

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
}
