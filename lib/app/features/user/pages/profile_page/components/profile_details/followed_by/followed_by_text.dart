// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart'; // Import this for TapGestureRecognizer
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/providers/user_followers_provider.dart';
import 'package:ice/app/features/user/providers/user_metadata_provider.dart';
import 'package:ice/app/router/app_routes.dart';

class FollowedByText extends ConsumerStatefulWidget {
  const FollowedByText({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  FollowedByTextState createState() => FollowedByTextState();
}

class FollowedByTextState extends ConsumerState<FollowedByText> {
  late TapGestureRecognizer _firstUserTapRecognizer;
  late TapGestureRecognizer _othersTapRecognizer;

  String? _firstUserPubkey;
  String? _secondUserPubkey;
  int? _numOthers;

  @override
  void initState() {
    super.initState();

    _firstUserTapRecognizer = TapGestureRecognizer()..onTap = _onFirstUserTap;
    _othersTapRecognizer = TapGestureRecognizer()..onTap = _onOthersTap;
  }

  @override
  void dispose() {
    _firstUserTapRecognizer.dispose();
    _othersTapRecognizer.dispose();
    super.dispose();
  }

  void _onFirstUserTap() {
    final pubkey = _firstUserPubkey;
    if (pubkey != null) {
      FeedProfileRoute(pubkey: pubkey).push<void>(context);
    }
  }

  void _onOthersTap() {
    final numOthers = _numOthers;
    if (numOthers != null && numOthers > 0) {
      if (numOthers == 1) {
        final pubkey = _secondUserPubkey;
        if (pubkey != null) {
          FeedProfileRoute(pubkey: pubkey).push<void>(context);
        }
      } else {
        // show all followers
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userFollowers = ref.watch(userFollowersProvider(widget.pubkey)).valueOrNull;

    if (userFollowers == null || userFollowers.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstUserPubkey = userFollowers.first;
    _firstUserPubkey = firstUserPubkey;

    final firstUserName =
        ref.watch(userMetadataProvider(firstUserPubkey)).valueOrNull?.displayName ?? '';

    final totalFollowers = userFollowers.length;
    final numOthers = totalFollowers - 1;
    _numOthers = numOthers;

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
        recognizer: _firstUserTapRecognizer,
      ),
    ];

    if (numOthers >= 1) {
      textSpans.add(
        TextSpan(
          text: context.i18n.profile_followed_by_and,
          style: defaultStyle,
        ),
      );

      final secondUserPubkey = userFollowers.elementAt(1);
      _secondUserPubkey = secondUserPubkey;
      final secondUserName =
          ref.watch(userMetadataProvider(secondUserPubkey)).valueOrNull?.displayName ?? '';
      textSpans.add(
        TextSpan(
          text: numOthers == 1 ? secondUserName : context.i18n.profile_followed_by_and_others,
          style: actionableStyle,
          recognizer: _othersTapRecognizer,
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
