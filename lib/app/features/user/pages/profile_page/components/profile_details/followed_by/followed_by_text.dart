// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart'; // Import this for TapGestureRecognizer
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import hooks
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_followers_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class FollowedByText extends HookConsumerWidget {
  const FollowedByText({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstUserTapRecognizer = useMemoized(TapGestureRecognizer.new);
    final othersTapRecognizer = useMemoized(TapGestureRecognizer.new);

    useEffect(
      () {
        return () {
          firstUserTapRecognizer.dispose();
          othersTapRecognizer.dispose();
        };
      },
      [firstUserTapRecognizer, othersTapRecognizer],
    );

    String? firstUserPubkey;
    String? secondUserPubkey;
    int? numOthers;

    void onFirstUserTap() {
      final pubkey = firstUserPubkey;
      if (pubkey != null) {
        FeedProfileRoute(pubkey: pubkey).push<void>(context);
      }
    }

    void onOthersTap() {
      final numOthersVal = numOthers;
      if (numOthersVal != null && numOthersVal > 0) {
        if (numOthersVal == 1) {
          final pubkey = secondUserPubkey;
          if (pubkey != null) {
            FeedProfileRoute(pubkey: pubkey).push<void>(context);
          }
        } else {
          // show all followers
        }
      }
    }

    firstUserTapRecognizer.onTap = onFirstUserTap;
    othersTapRecognizer.onTap = onOthersTap;

    final userFollowers = ref.watch(userFollowersProvider(pubkey)).valueOrNull;

    if (userFollowers == null || userFollowers.isEmpty) {
      return const SizedBox.shrink();
    }

    firstUserPubkey = userFollowers.first;

    final firstUserName =
        ref.watch(userMetadataProvider(firstUserPubkey)).valueOrNull?.displayName ?? '';

    final totalFollowers = userFollowers.length;
    numOthers = totalFollowers - 1;

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
        text: firstUserName,
        style: actionableStyle,
        recognizer: firstUserTapRecognizer,
      ),
    ];

    if (numOthers >= 1) {
      textSpans.add(
        TextSpan(
          text: context.i18n.profile_followed_by_and,
          style: defaultStyle,
        ),
      );

      secondUserPubkey = userFollowers.elementAt(1);
      final secondUserName =
          ref.watch(userMetadataProvider(secondUserPubkey)).valueOrNull?.displayName ?? '';
      textSpans.add(
        TextSpan(
          text: numOthers == 1 ? secondUserName : context.i18n.profile_followed_by_and_others,
          style: actionableStyle,
          recognizer: othersTapRecognizer,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
