// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item.dart';
import 'package:ion/app/features/user/pages/profile_page/components/header/context_menu_item_divider.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/report_user_modal/report_user_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryContextMenu extends HookConsumerWidget {
  const StoryContextMenu({
    required this.pubkey,
    required this.child,
    this.opacity = 1,
    super.key,
  });

  final String pubkey;
  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMuted = ref.watch(globalMuteProvider);
    final menuWidth = useState<double>(100.0.s);

    final i18n = context.i18n;

    final updateWidth = useCallback(
      (Size size) {
        if (size.width > menuWidth.value) {
          menuWidth.value = size.width;
        }
      },
      [],
    );

    return OverlayMenu(
      onOpen: () {
        ref.read(storyPauseControllerProvider.notifier).paused = true;
        ref.read(storyMenuControllerProvider.notifier).menuOpen = true;
      },
      onClose: () {
        ref.read(storyPauseControllerProvider.notifier).paused = false;
        ref.read(storyMenuControllerProvider.notifier).menuOpen = false;
      },
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: Column(
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
              onLayout: updateWidth,
            ),
            const ContextMenuItemDivider(),
            ContextMenuItem(
              label: isMuted ? i18n.button_unmute : i18n.button_mute,
              iconAsset: isMuted ? Assets.svg.iconChannelUnmute : Assets.svg.iconChannelMute,
              onPressed: () => ref.read(globalMuteProvider.notifier).toggle(),
              onLayout: updateWidth,
            ),
            const ContextMenuItemDivider(),
            ContextMenuItem(
              label: i18n.button_unfollow,
              iconAsset: Assets.svg.iconCategoriesUnflow,
              onPressed: () {
                closeMenu();
              },
              onLayout: updateWidth,
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
