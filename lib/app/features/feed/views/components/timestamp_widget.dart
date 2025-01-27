// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/utils/date.dart';

enum TimestampFormat { short, detailed }

class TimestampWidget extends ConsumerWidget {
  const TimestampWidget({
    required this.createdAt,
    required this.timeFormat,
    super.key,
    this.style,
  });

  final DateTime createdAt;
  final TimestampFormat timeFormat;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final formattedTime = timeFormat == TimestampFormat.detailed
        ? formatDetailedTimestamp(createdAt, locale: locale)
        : formatShortTimestamp(createdAt, locale: locale);

    return Text(
      formattedTime,
      style: style ??
          context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.tertararyText,
          ),
    );
  }
}
