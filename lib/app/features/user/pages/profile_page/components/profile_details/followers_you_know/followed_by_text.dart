// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
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

    final firstUserMetadata = ref.watch(cachedUserMetadataProvider(firstUserPubkey));

    final userTapRecognizer = useTapGestureRecognizer(
      onTap: () => ProfileRoute(pubkey: firstUserPubkey).push<void>(context),
    );

    final othersTapRecognizer = useTapGestureRecognizer(
      onTap: () => FollowListRoute(pubkey: firstUserPubkey, followType: FollowType.followers)
          .push<void>(context),
    );

    if (firstUserMetadata == null) {
      return const SizedBox.shrink();
    }

    final defaultStyle = context.theme.appTextThemes.body2.copyWith(
      color: context.theme.appColors.primaryText,
    );

    final actionableStyle = context.theme.appTextThemes.body2.copyWith(
      color: context.theme.appColors.darkBlue,
    );

    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: context.i18n.profile_followed_by,
              style: defaultStyle,
            ),
            TextSpan(
              text: firstUserMetadata.data.displayName,
              style: actionableStyle,
              recognizer: userTapRecognizer,
            ),
            if (pubkeys.length > 1) ...[
              TextSpan(
                text: context.i18n.profile_followed_by_and,
                style: defaultStyle,
              ),
              TextSpan(
                text: context.i18n.profile_followed_by_and_others,
                style: actionableStyle,
                recognizer: othersTapRecognizer,
              ),
            ],
          ],
        ),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
