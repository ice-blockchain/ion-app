import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/extensions.dart';
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
    final menuWidth = useState<double>(100.0.s);

    final updateWidth = useCallback(
      (Size size) {
        if (size.width > menuWidth.value) {
          menuWidth.value = size.width;
        }
      },
      [],
    );

    return OverlayMenu(
      offset: Offset(-menuWidth.value + 24.0.s, 6.0.s),
      menuBuilder: (closeMenu) => OverlayMenuContainer(
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContextMenuItem(
                label: context.i18n.button_report,
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
                label: context.i18n.button_mute,
                iconAsset: Assets.svg.iconChannelMute,
                onPressed: () {
                  closeMenu();
                },
                onLayout: updateWidth,
              ),
              const ContextMenuItemDivider(),
              ContextMenuItem(
                label: context.i18n.button_unfollow,
                iconAsset: Assets.svg.iconCategoriesUnflow,
                onPressed: () {
                  closeMenu();
                },
                onLayout: updateWidth,
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
