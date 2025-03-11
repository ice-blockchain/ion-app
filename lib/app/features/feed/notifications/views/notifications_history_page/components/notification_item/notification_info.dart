// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/model/notification_data.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/l10n/i10n.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationInfo extends HookConsumerWidget {
  const NotificationInfo({
    required this.notificationData,
    super.key,
  });

  final NotificationData notificationData;

  TextSpan _getDateTextSpan(BuildContext context) {
    return TextSpan(
      text:
          ' • ${timeago.format(notificationData.timestamp, locale: 'en_short').replaceFirst('~', '')}',
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.tertararyText,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDatas =
        notificationData.pubkeys.take(notificationData.pubkeys.length == 2 ? 2 : 1).map((pubkey) {
      return ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    }).toList();

    if (userDatas.contains(null)) {
      return Skeleton(
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            width: 240.0.s,
            height: 20.0.s,
          ),
        ),
      );
    }

    final newTapRecognizers = <TapGestureRecognizer>[];
    final textSpan = replaceString(
      notificationData.type.getDescription(context, notificationData.pubkeys),
      tagRegex('username'),
      (String text, int index) {
        final pubkey = notificationData.pubkeys[index];
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
      TextSpan(children: [textSpan, _getDateTextSpan(context)]),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.primaryText,
      ),
    );
  }
}
