// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/view/pages/admin_type_selection_modal/admin_type_selection_modal.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class AdminCard extends ConsumerWidget {
  const AdminCard({
    required this.pubkey,
    required this.channelAdminType,
    this.onTap,
    super.key,
    this.createChannelFlow = false,
  });

  final String pubkey;
  final VoidCallback? onTap;
  final ChannelAdminType channelAdminType;
  final bool createChannelFlow;
  static double get itemHeight => 60.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataResult = ref.watch(userMetadataProvider(pubkey));

    return userMetadataResult.maybeWhen(
      data: (userMetadata) {
        if (userMetadata == null) {
          return const SizedBox.shrink();
        }
        return ListItem.user(
          onTap: () {
            showSimpleBottomSheet<void>(
              context: context,
              child: AdminTypeSelectionModal(
                adminPubkey: pubkey,
                adminType: channelAdminType,
                createChannelFlow: createChannelFlow,
              ),
            );
          },
          title: Text(userMetadata.data.displayName),
          subtitle: Text(prefixUsername(username: userMetadata.data.name, context: context)),
          profilePicture: userMetadata.data.picture,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 8.0.s),
          backgroundColor: context.theme.appColors.tertararyBackground,
          borderRadius: BorderRadius.circular(16.0.s),
          constraints: BoxConstraints(minHeight: itemHeight),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                channelAdminType.getTitle(context),
                style: context.theme.appTextThemes.body
                    .copyWith(color: context.theme.appColors.primaryAccent),
              ),
              Padding(
                padding: EdgeInsets.all(4.0.s),
                child: Assets.svg.iconArrowRight.icon(color: context.theme.appColors.secondaryText),
              ),
            ],
          ),
        );
      },
      orElse: () => ItemLoadingState(
        itemHeight: itemHeight,
      ),
    );
  }
}
