// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum TransactionType {
  send('send'),
  receive('receive');

  const TransactionType(this.value);

  factory TransactionType.fromDirection(String direction) {
    return switch (direction.toLowerCase()) {
      'in' => TransactionType.receive,
      'out' => TransactionType.send,
      String() => throw FormatException(
          'Failed to build TransactionType from direction $direction',
        ),
    };
  }

  factory TransactionType.fromValue(String value) {
    final lowered = value.toLowerCase();
    return TransactionType.values.firstWhere(
      (type) => type.value == lowered,
      orElse: () => throw FormatException('Failed to build TransactionType from value $value'),
    );
  }

  final String value;

  bool get isSend => this == TransactionType.send;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      TransactionType.send => context.i18n.wallet_sent,
      TransactionType.receive => context.i18n.wallet_received,
    };
  }

  String get iconAsset {
    return switch (this) {
      TransactionType.send => Assets.svg.iconButtonSend,
      TransactionType.receive => Assets.svg.iconButtonReceive,
    };
  }

  String get sign {
    return switch (this) {
      TransactionType.send => '-',
      TransactionType.receive => '+',
    };
  }
}
