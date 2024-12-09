// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_colored_border.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class CurrentUserStoryListItem extends HookConsumerWidget {
  const CurrentUserStoryListItem({
    required this.pubkey,
    required this.gradient,
    super.key,
  });

  final String pubkey;
  final Gradient? gradient;

  static double get plusSize => 18.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewed = useState(false);
    final currentUserMetadata = ref.watch(currentUserMetadataProvider);

    return currentUserMetadata.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) return const SizedBox.shrink();

        return PermissionAwareWidget(
          permissionType: Permission.camera,
          onGranted: () => Random().nextBool()
              ? StoryRecordRoute().push<void>(context)
              : StoryViewerRoute(pubkey: pubkey).push<void>(context),
          requestDialog: const PermissionRequestSheet(permission: Permission.camera),
          settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
          builder: (context, onPressed) {
            return GestureDetector(
              onTap: onPressed,
              child: Hero(
                tag: 'story-$pubkey',
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: StoryListItem.width,
                    height: StoryListItem.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            StoryColoredBorder(
                              size: StoryListItem.width,
                              color: context.theme.appColors.strokeElements,
                              gradient: viewed.value ? null : gradient,
                              child: StoryColoredBorder(
                                size: StoryListItem.width - StoryListItem.borderSize * 2,
                                color: context.theme.appColors.secondaryBackground,
                                child: Avatar(
                                  size: StoryListItem.width - StoryListItem.borderSize * 4,
                                  imageUrl: userMetadata.data.picture,
                                ),
                              ),
                            ),
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
                            context.i18n.common_you,
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
              ),
            );
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
