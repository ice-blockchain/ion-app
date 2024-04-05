import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

enum TransactionType {
  send,
  receive;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      TransactionType.send => context.i18n.wallet_sent,
      TransactionType.receive => context.i18n.wallet_received,
    };
  }

  AssetGenImage get iconAsset {
    return switch (this) {
      TransactionType.send => Assets.images.icons.iconButtonSend,
      TransactionType.receive => Assets.images.icons.iconButtonReceive,
    };
  }

  String get sign {
    return switch (this) {
      TransactionType.send => '-',
      TransactionType.receive => '+',
    };
  }
}
