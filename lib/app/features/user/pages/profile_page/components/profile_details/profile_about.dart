// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/rich_text_with_highlights/rich_text_with_highlights.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class ProfileAbout extends ConsumerWidget {
  const ProfileAbout({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about =
        ref.watch(userMetadataProvider(pubkey).select((state) => state.valueOrNull?.data.about));

    if (about == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: RichTextWithHighlights(
        text: about,
        style: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        onHashtagTap: (hashtag) => FeedAdvancedSearchRoute(query: hashtag).go(context),
      ),
    );
  }
}
