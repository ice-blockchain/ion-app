// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/pages/delete_story_modal/delete_story_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/report_user_modal/report_user_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryContextMenu extends HookConsumerWidget {
  const StoryContextMenu({
    required this.pubkey,
    required this.post,
    required this.child,
    this.isCurrentUser = false,
    this.opacity = 1,
    super.key,
  });

  final String pubkey;
  final ModifiablePostEntity post;
  final Widget child;
  final bool isCurrentUser;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuWidth = useState<double>(100.0.s);
    final isDeletingStory = useState(false);

    final updateWidth = useCallback(
      (Size size) {
        if (size.width > menuWidth.value) {
          menuWidth.value = size.width;
        }
      },
      [],
    );

    final handleDeleteConfirmation = useCallback(
      () async {
        isDeletingStory.value = true;

        final confirmed = await showSimpleBottomSheet<bool>(
          context: context,
          child: DeleteStoryModal(eventReference: post.toEventReference()),
        );

        if ((confirmed ?? false) && context.mounted) {
          Navigator.of(context).pop();
        } else {
          ref.read(storyPauseControllerProvider.notifier).paused = false;
        }

        isDeletingStory.value = false;
      },
      [],
    );

    return OverlayMenu(
      onOpen: () {
        ref.read(storyPauseControllerProvider.notifier).paused = true;
        ref.read(storyMenuControllerProvider.notifier).menuOpen = true;
      },
      onClose: () {
        if (!isDeletingStory.value) {
          ref.read(storyPauseControllerProvider.notifier).paused = false;
        }
        ref.read(storyMenuControllerProvider.notifier).menuOpen = false;
      },
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: _StoryContextMenuContent(
          pubkey: pubkey,
          isCurrentUser: isCurrentUser,
          onUpdateWidth: updateWidth,
          onClose: closeMenu,
          onDeleteRequest: () {
            closeMenu();
            handleDeleteConfirmation();
          },
        ),
      ),
      child: child,
    );
  }
}

class _StoryContextMenuContent extends HookConsumerWidget {
  const _StoryContextMenuContent({
    required this.pubkey,
    required this.isCurrentUser,
    required this.onUpdateWidth,
    required this.onClose,
    required this.onDeleteRequest,
  });

  final String pubkey;
  final bool isCurrentUser;
  final void Function(Size) onUpdateWidth;
  final VoidCallback onClose;
  final VoidCallback onDeleteRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCurrentUser)
          _CurrentUserMenuItems(
            onDeleteRequest: onDeleteRequest,
            onUpdateWidth: onUpdateWidth,
          )
        else
          _OtherUserMenuItems(
            pubkey: pubkey,
            onClose: onClose,
            onUpdateWidth: onUpdateWidth,
          ),
      ],
    );
  }
}

class _CurrentUserMenuItems extends ConsumerWidget {
  const _CurrentUserMenuItems({
    required this.onDeleteRequest,
    required this.onUpdateWidth,
  });

  final VoidCallback onDeleteRequest;
  final void Function(Size) onUpdateWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = context.i18n;
    final colors = context.theme.appColors;

    return ContextMenuItem(
      label: i18n.button_delete,
      iconAsset: Assets.svg.iconBlockDelete,
      onPressed: onDeleteRequest,
      onLayout: onUpdateWidth,
      textColor: colors.attentionRed,
      iconColor: colors.attentionRed,
    );
  }
}

class _OtherUserMenuItems extends ConsumerWidget {
  const _OtherUserMenuItems({
    required this.pubkey,
    required this.onClose,
    required this.onUpdateWidth,
  });

  final String pubkey;
  final VoidCallback onClose;
  final void Function(Size) onUpdateWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = context.i18n;
    final isMuted = ref.watch(globalMuteProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContextMenuItem(
          label: i18n.button_report,
          iconAsset: Assets.svg.iconReport,
          onPressed: () {
            showSimpleBottomSheet<void>(
              context: context,
              child: ReportUserModal(pubkey: pubkey),
            );
          },
          onLayout: onUpdateWidth,
        ),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: isMuted ? i18n.button_unmute : i18n.button_mute,
          iconAsset: isMuted ? Assets.svg.iconChannelUnmute : Assets.svg.iconChannelMute,
          onPressed: () => ref.read(globalMuteProvider.notifier).toggle(),
          onLayout: onUpdateWidth,
        ),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: i18n.button_unfollow,
          iconAsset: Assets.svg.iconCategoriesUnflow,
          onPressed: onClose,
          onLayout: onUpdateWidth,
        ),
      ],
    );
  }
}
