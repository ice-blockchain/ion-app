// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/overlay_menu/components/overlay_menu_item.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/providers/delete_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class OwnEntityMenu extends ConsumerWidget {
  const OwnEntityMenu({
    required this.eventReference,
    this.iconColor,
    this.onDelete,
    super.key,
  });

  static double get iconSize => 20.0.s;

  final EventReference eventReference;
  final Color? iconColor;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OverlayMenu(
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: OverlayMenuItem(
              label: context.i18n.post_menu_delete,
              labelColor: context.theme.appColors.attentionRed,
              icon: Assets.svg.iconBlockDelete.icon(
                size: iconSize,
                color: context.theme.appColors.attentionRed,
              ),
              onPressed: () async {
                closeMenu();
                await ref.read(deleteEntityProvider(eventReference).future);
                onDelete?.call();
              },
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: iconColor ?? context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}
