// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/view/pages/delete_admin_modal/delete_admin_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAdminButton extends ConsumerWidget {
  const DeleteAdminButton({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return ScreenSideOffset.small(
      child: ListItem(
        contentPadding: EdgeInsetsDirectional.only(
          start: ScreenSideOffset.defaultSmallMargin,
          end: 8.0.s,
        ),
        title: Text(
          context.i18n.channel_create_admin_type_remove,
          style: textStyles.body,
        ),
        backgroundColor: colors.tertararyBackground,
        onTap: () async {
          final isDeleted = await showSimpleBottomSheet<bool>(
            context: context,
            child: DeleteAdminModal(pubkey: pubkey),
          );
          if (isDeleted != null && isDeleted && context.mounted) {
            context.pop();
          }
        },
        leading: ButtonIconFrame(
          containerSize: 36.0.s,
          borderRadius: BorderRadius.circular(10.0.s),
          color: colors.onPrimaryAccent,
          icon: Assets.svg.iconBlockDelete.icon(
            size: 24.0.s,
            color: colors.attentionRed,
          ),
          border: Border.fromBorderSide(
            BorderSide(color: colors.onTerararyFill, width: 1.0.s),
          ),
        ),
        trailing: Padding(
          padding: EdgeInsets.all(8.0.s),
          child: Assets.svg.iconArrowRight.icon(
            color: colors.tertararyText,
          ),
        ),
      ),
    );
  }
}
