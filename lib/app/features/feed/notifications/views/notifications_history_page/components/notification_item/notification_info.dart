// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/l10n/i10n.dart';

class NotificationInfo extends HookConsumerWidget {
  const NotificationInfo({
    required this.notification,
    super.key,
  });

  final IonNotification notification;

  TextSpan _getDateTextSpan(BuildContext context, {required Locale locale}) {
    return TextSpan(
      text: ' • ${formatShortTimestamp(notification.timestamp, locale: locale)}',
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.tertararyText,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final userDatas =
        notification.pubkeys.take(notification.pubkeys.length == 2 ? 2 : 1).map((pubkey) {
      return ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    }).toList();

    if (userDatas.contains(null)) {
      return Skeleton(
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            width: 240.0.s,
            height: 19.0.s,
          ),
        ),
      );
    }

    final newTapRecognizers = <TapGestureRecognizer>[];
    final textSpan = replaceString(
      notification.getDescription(context),
      tagRegex('username'),
      (String text, int index) {
        final pubkey = notification.pubkeys[index];
        final userData = userDatas[index];
        if (userData == null) {
          return const TextSpan(text: '');
        }
        final recognizer = TapGestureRecognizer()
          ..onTap = () => ProfileRoute(pubkey: pubkey).push<void>(context);
        newTapRecognizers.add(recognizer);
        return TextSpan(
          text: userData.data.displayName.isEmpty ? userData.data.name : userData.data.displayName,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
          recognizer: recognizer,
        );
      },
    );

    useEffect(
      () {
        return () {
          for (final recognizer in newTapRecognizers) {
            recognizer.dispose();
          }
        };
      },
      [newTapRecognizers],
    );

    return Text.rich(
      TextSpan(children: [textSpan, _getDateTextSpan(context, locale: locale)]),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.primaryText,
      ),
    );
  }
}
