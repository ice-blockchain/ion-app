// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/utils/date.dart';

class TimestampWidget extends ConsumerWidget {
  const TimestampWidget({
    required this.createdAt,
    super.key,
    this.showDetailed = false,
    this.style,
  });

  final DateTime createdAt;
  final bool showDetailed;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final formattedTime = showDetailed
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
