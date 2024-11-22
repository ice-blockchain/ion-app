// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/channel_type_selection_modal/components/channel_type_selection_list_item.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ChannelTypeSelectionModal extends HookConsumerWidget {
  const ChannelTypeSelectionModal({
    required this.channelType,
    required this.onUpdated,
    super.key,
  });

  final ChannelType channelType;
  final void Function(ChannelType channelType) onUpdated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChannelType = useState(channelType);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          actions: [
            NavigationCloseButton(
              onPressed: () => context.pop(),
            ),
          ],
          title: Text(context.i18n.channel_create_type_select_title),
        ),
        for (final ChannelType type in ChannelType.values.toSet())
          ScreenSideOffset.small(
            child: Column(
              children: [
                ChannelTypeSelectionListItem(
                  channelType: type,
                  onTap: () {
                    selectedChannelType.value = type;
                    onUpdated(type);
                  },
                  isSelected: selectedChannelType.value == type,
                ),
                SizedBox(height: 16.0.s),
              ],
            ),
          ),
        ScreenBottomOffset(),
      ],
    );
  }
}
