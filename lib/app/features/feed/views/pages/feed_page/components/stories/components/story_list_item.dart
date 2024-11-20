// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_colored_border.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class StoryListItem extends HookConsumerWidget {
  const StoryListItem({
    required this.pubkey,
    super.key,
    this.gradient,
  });

  final String pubkey;
  final Gradient? gradient;

  static double get width => 65.0.s;

  static double get height => 91.0.s;

  static double get plusSize => 18.0.s;

  static double get borderSize => 2.0.s;

  static const _defaultAvatarUrl = 'https://i.pravatar.cc/150?u=@me';
  static const _defaultUserLabel = 'you';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewed = useState(false);
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider) ?? '';
    final userMetadataAsync = ref.watch(userMetadataProvider(pubkey));

    return userMetadataAsync.maybeWhen(
      data: (userMetadata) => GestureDetector(
        onTap: () {
          if (userMetadata == null) return;

          StoryViewerRoute(pubkey: pubkey).push<void>(context);
        },
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  StoryColoredBorder(
                    size: width,
                    color: context.theme.appColors.strokeElements,
                    gradient: viewed.value ? null : gradient,
                    child: StoryColoredBorder(
                      size: width - borderSize * 2,
                      color: context.theme.appColors.secondaryBackground,
                      child: Avatar(
                        size: width - borderSize * 4,
                        imageUrl: userMetadata?.data.picture ?? _defaultAvatarUrl,
                      ),
                    ),
                  ),
                  if (userMetadata?.pubkey == currentUserPubkey)
                    Positioned(
                      bottom: -plusSize / 2,
                      child: PlusIcon(
                        size: plusSize,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0.s),
                child: Text(
                  userMetadata?.pubkey == currentUserPubkey
                      ? _defaultUserLabel
                      : userMetadata?.data.name ?? '',
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
