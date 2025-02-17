// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/date.dart';

class ChatDateHeaderText extends StatelessWidget {
  const ChatDateHeaderText({
    required this.date,
    super.key,
  });
  final DateTime date;

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
        toPastDateDisplayValue(
          date.millisecondsSinceEpoch,
          context,
          dateFormat: DateFormat.MMMMd(),
        ),
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.onTertararyBackground,
        ),
      ),
    );
  }
}
