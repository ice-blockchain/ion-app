// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/utils/date.dart';

class TimestampWidget extends StatelessWidget {
  const TimestampWidget({
    required this.createdAt,
    this.showDetailed = false,
    super.key,
  });
  final DateTime createdAt;
  final bool showDetailed;

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        showDetailed ? formatDetailedPostTime(createdAt) : formatFeedTimestamp(createdAt);

    return Text(
      formattedTime,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
