// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/feed/data/models/delete/delete_confirmation_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/entity_delete_confirmation_modal/entity_delete_confirmation_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/features/user/providers/report_notifier.c.dart';
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
    final isDeletingStory = useState(false);

    final handleDeleteConfirmation = useCallback(
      () async {
        final currentStory = ref.read(storyViewingControllerProvider(pubkey)).currentStory;
        if (currentStory == null) {
          return;
        }

        isDeletingStory.value = true;

        final confirmed = await showSimpleBottomSheet<bool>(
          context: context,
          child: EntityDeleteConfirmationModal(
            eventReference: currentStory.toEventReference(),
            deleteConfirmationType: DeleteConfirmationType.story,
          ),
        );

        if ((confirmed ?? false) && context.mounted) {
          Navigator.of(context).pop();
        } else {
          ref.read(storyPauseControllerProvider.notifier).paused = false;
        }

        isDeletingStory.value = false;
      },
      [pubkey],
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
    required this.onClose,
    required this.onDeleteRequest,
  });

  final String pubkey;
  final bool isCurrentUser;
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
          )
        else
          _OtherUserMenuItems(
            pubkey: pubkey,
            onClose: onClose,
          ),
      ],
    );
  }
}

class _CurrentUserMenuItems extends ConsumerWidget {
  const _CurrentUserMenuItems({
    required this.onDeleteRequest,
  });

  final VoidCallback onDeleteRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = context.i18n;
    final colors = context.theme.appColors;

    return ContextMenuItem(
      label: i18n.button_delete,
      iconAsset: Assets.svg.iconBlockDelete,
      onPressed: onDeleteRequest,
      textColor: colors.attentionRed,
      iconColor: colors.attentionRed,
    );
  }
}

class _OtherUserMenuItems extends ConsumerWidget {
  const _OtherUserMenuItems({
    required this.pubkey,
    required this.onClose,
  });

  final String pubkey;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = context.i18n;
    final isMuted = ref.watch(globalMuteNotifierProvider);

    ref.displayErrors(reportNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContextMenuItem(
          label: i18n.button_report,
          iconAsset: Assets.svg.iconReport,
          onPressed: () {
            onClose();
            final currentStory = ref.read(storyViewingControllerProvider(pubkey)).currentStory;

            if (currentStory == null) {
              return;
            }

            ref
                .read(reportNotifierProvider.notifier)
                .report(ReportReason.content(eventReference: currentStory.toEventReference()));
          },
        ),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: isMuted ? i18n.button_unmute : i18n.button_mute,
          iconAsset: isMuted ? Assets.svg.iconChannelUnmute : Assets.svg.iconChannelMute,
          onPressed: () {
            ref.read(globalMuteNotifierProvider.notifier).toggle();
          },
        ),
        const ContextMenuItemDivider(),
        ContextMenuItem(
          label: i18n.button_unfollow,
          iconAsset: Assets.svg.iconCategoriesUnflow,
          onPressed: () {
            onClose();
            showSimpleBottomSheet<void>(
              context: context,
              child: UnfollowUserModal(pubkey: pubkey),
            );
          },
        ),
      ],
    );
  }
}
