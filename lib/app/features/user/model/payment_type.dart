// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum PaymentType {
  send,
  receive;

  String get iconAsset {
    return switch (this) {
      PaymentType.send => Assets.svg.walletChatSendpayment,
      PaymentType.receive => Assets.svg.walletChatRequestpayment,
    };
  }

  String getTitle(BuildContext context) {
    return switch (this) {
      PaymentType.send => context.i18n.profile_send_option_title,
      PaymentType.receive => context.i18n.profile_request_option_title,
    };
  }

  String getDesc(BuildContext context) {
    return switch (this) {
      PaymentType.send => context.i18n.profile_send_option_desc,
      PaymentType.receive => context.i18n.profile_request_option_desc,
    };
  }
}
