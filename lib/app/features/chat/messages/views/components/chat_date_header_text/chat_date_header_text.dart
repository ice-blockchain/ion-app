// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/extensions/extensions.dart';

class ChatDateHeaderText extends StatelessWidget {
  const ChatDateHeaderText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.0.s,
        vertical: 1.0.s,
      ),
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Text(
        DateFormat.MMMMd().format(DateTime.now()),
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.onTertararyBackground,
        ),
      ),
    );
  }
}
