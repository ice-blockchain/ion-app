// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/hooks/use_tap_gesture_recognizer.dart';
import 'package:ion/app/router/app_routes.c.dart';

class FollowedByText extends HookConsumerWidget {
  const FollowedByText({
    required this.pubkeys,
    super.key,
  });

  final List<String> pubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstUserPubkey = pubkeys.first;

    // User metadata is fetched alongside the `followersYouKnowDataSourceProvider`, so don't fetch it manually
    final firstUserMetadata = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<UserMetadataEntity>(
          UserMetadataEntity.cacheKeyBuilder(pubkey: firstUserPubkey),
        ),
      ),
    );

    final userTapRecognizer = useTapGestureRecognizer(
      onTap: () => ProfileRoute(pubkey: firstUserPubkey).push<void>(context),
    );

    final othersTapRecognizer = useTapGestureRecognizer();

    if (firstUserMetadata == null) {
      return const SizedBox.shrink();
    }

    final defaultStyle = context.theme.appTextThemes.body2.copyWith(
      color: context.theme.appColors.primaryText,
    );

    final actionableStyle = context.theme.appTextThemes.body2.copyWith(
      color: context.theme.appColors.darkBlue,
    );

    final textSpans = [
      TextSpan(
        text: context.i18n.profile_followed_by,
        style: defaultStyle,
      ),
      TextSpan(
        text: firstUserMetadata.data.displayName,
        style: actionableStyle,
        recognizer: userTapRecognizer,
      ),
    ];

    if (pubkeys.length > 1) {
      textSpans
        ..add(
          TextSpan(
            text: context.i18n.profile_followed_by_and,
            style: defaultStyle,
          ),
        )
        ..add(
          TextSpan(
            text: context.i18n.profile_followed_by_and_others,
            style: actionableStyle,
            recognizer: othersTapRecognizer,
          ),
        );
    }

    return Expanded(
      child: RichText(
        text: TextSpan(children: textSpans),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
